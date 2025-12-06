use std::{
    collections::BTreeMap,
    fs, io, mem,
    net::{AddrParseError, IpAddr, Ipv6Addr},
    thread,
    time::{Duration, SystemTime},
};

const FILE_HOSTS: &str = "/etc/hosts";
const FILE_HOSTS_NEW: &str = "/etc/.hosts.new";
const FILE_DYN_HOSTS: &str = "/etc/dynhosts";
const MARKER_START: &str = "### DYNAMIC HOSTS START ###";
const MARKER_END: &str = "###  DYNAMIC HOSTS END  ###";
const ADDR_VOID: IpAddr = IpAddr::V6(Ipv6Addr::new(0x100, 0, 0, 0, 0, 0, 0, 0));
const TIMEOUT: Duration = Duration::from_millis(100);
const INTERVAL: Duration = Duration::from_millis(1000);

type Hosts = BTreeMap<String, Host>;

#[derive(Default)]
struct Host {
    addr: Option<IpAddr>,
    addrs: Vec<IpAddr>,
}

macro_rules! pushln {
    ($str:ident, $line:expr) => {{
        $str.push_str($line);
        $str.push('\n');
    }};
}

fn load_config(stamp: &mut SystemTime) -> io::Result<Option<String>> {
    let time = fs::metadata(FILE_DYN_HOSTS)?.modified()?;

    if time > *stamp {
        println!("Loading configuration...");
        *stamp = time;
        return Ok(Some(fs::read_to_string(FILE_DYN_HOSTS)?));
    }

    Ok(None)
}

fn parse_config(config: &str) -> Result<Hosts, AddrParseError> {
    let mut hosts = Hosts::new();

    for line in config.lines() {
        let mut fields = line.split_whitespace();

        if let Some(host) = fields.next() {
            let entry = hosts.entry(host.into()).or_default();

            for field in fields {
                entry.addrs.push(field.parse()?);
            }
        }
    }

    println!("Done. Managing {} hosts.", hosts.len());
    Ok(hosts)
}

fn ping(addr: &&IpAddr) -> bool {
    ping::new(**addr)
        .timeout(TIMEOUT)
        .socket_type(ping::RAW) // TODO: Remove this once DGRAM sockets work
        .send()
        .is_ok()
}

fn update_hosts(data: &str) -> io::Result<()> {
    let prev = fs::read_to_string(FILE_HOSTS).unwrap_or_default();
    let mut new = String::new();
    let mut keep = true;
    let mut found = false;

    for line in prev.lines() {
        match line {
            MARKER_START => {
                pushln!(new, MARKER_START);
                new.push_str(data);
                pushln!(new, MARKER_END);

                keep = false;
                found = true;
            }

            MARKER_END => keep = true,
            _ if keep => pushln!(new, line),
            _ => (),
        }
    }

    if !found {
        pushln!(new, MARKER_START);
        new.push_str(data);
        pushln!(new, MARKER_END);
    }

    if prev != new {
        fs::write(FILE_HOSTS_NEW, new)?;
        fs::rename(FILE_HOSTS_NEW, FILE_HOSTS)?;
    }

    Ok(())
}

fn main() {
    let mut stamp = SystemTime::UNIX_EPOCH;
    let mut hosts = Hosts::new();

    loop {
        match load_config(&mut stamp) {
            Err(err) => eprintln!("Failed to read {FILE_DYN_HOSTS}: {err}"),
            Ok(None) => (),

            Ok(Some(config)) => match parse_config(&config) {
                Err(err) => eprintln!("Failed to parse config: {err}"),
                Ok(cfg) => hosts = cfg,
            },
        }

        let mut addrs = BTreeMap::new();
        addrs.insert(ADDR_VOID, vec!["void"]);

        for (name, host) in &mut hosts {
            let addr = host.addrs.iter().find(ping).copied();
            let prev = mem::replace(&mut host.addr, addr);

            match (prev, addr) {
                (None, Some(addr)) => println!("{name}: {addr}"),
                (Some(_), None) => println!("{name}: N/A"),
                (Some(from), Some(to)) if from != to => println!("{name}: {from} -> {to}"),
                _ => (),
            }

            let addr = addr.unwrap_or(ADDR_VOID);
            addrs.entry(addr).or_default().push(name);
        }

        let mut data = String::new();

        for (addr, hosts) in addrs {
            data.push_str(&addr.to_string());
            data.push(' ');

            for host in hosts {
                data.push_str(host);
                data.push(' ');
            }

            data.pop();
            data.push('\n');
        }

        if let Err(err) = update_hosts(&data) {
            eprintln!("Failed to update {FILE_HOSTS}: {err}");
        }

        thread::sleep(INTERVAL);
    }
}
