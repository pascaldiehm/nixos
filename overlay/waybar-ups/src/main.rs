use std::{
    env,
    io::{self, Read, Write},
    net::TcpStream,
    num::ParseIntError,
    thread,
    time::Duration,
};

const INTERVAL: Duration = Duration::from_millis(1000);

#[derive(Debug)]
enum Error {
    Format,
    Io(io::Error),
    Nut(String),
    ParseInt(ParseIntError),
}

struct Status {
    charge: u8,
    power: u16,
    state: &'static str,
}

impl std::fmt::Display for Error {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Format => f.write_str("Format error: Illegal message format"),
            Self::Io(err) => f.write_fmt(format_args!("IO error: {err}")),
            Self::Nut(err) => f.write_fmt(format_args!("Nut error: {err}")),
            Self::ParseInt(err) => f.write_fmt(format_args!("ParseInt error: {err}")),
        }
    }
}

impl std::error::Error for Error {}

impl From<io::Error> for Error {
    fn from(value: io::Error) -> Self {
        Self::Io(value)
    }
}

impl From<ParseIntError> for Error {
    fn from(value: ParseIntError) -> Self {
        Self::ParseInt(value)
    }
}

fn connect(host: &str) -> Result<TcpStream, Error> {
    Ok(TcpStream::connect(format!("{host}:3493"))?)
}

fn get_var(stream: &mut TcpStream, ups: &str, var: &str) -> Result<String, Error> {
    writeln!(stream, "GET VAR {ups} {var}")?;

    let mut buf = [0; 1024];
    let len = stream.read(&mut buf)?;
    let text = String::from_utf8_lossy(&buf[..len]);
    let mut fields = text.trim().splitn(4, ' ');

    match fields.next() {
        Some("VAR") => match fields.nth(2) {
            Some(val) => Ok(val.trim_matches('"').into()),
            None => Err(Error::Format),
        },

        Some("ERR") => match fields.next() {
            Some(err) => Err(Error::Nut(err.into())),
            None => Err(Error::Format),
        },

        None => Err(Error::Format),
        Some(_) => Err(Error::Format),
    }
}

fn get_status(mut stream: TcpStream, ups: &str) -> Result<Status, Error> {
    let charge: u8 = get_var(&mut stream, ups, "battery.charge")?.parse()?;
    let power: u16 = get_var(&mut stream, ups, "ups.realpower")?.parse()?;
    let status = get_var(&mut stream, ups, "ups.status")?;

    let state = if status.contains("DISCHRG") {
        "discharging"
    } else if charge == 100 {
        "full"
    } else {
        "charging"
    };

    Ok(Status {
        charge,
        power,
        state,
    })
}

fn main() {
    let mut args = env::args();
    let host = args.nth(1).expect("Missing host");
    let ups = args.next().expect("Missing UPS");

    loop {
        match connect(&host).and_then(|s| get_status(s, &ups)) {
            Ok(status) => println!(
                r#"{{ "alt": "{0}", "class": "{0}", "percentage": {1}, "tooltip": "{2}W" }}"#,
                status.state, status.charge, status.power
            ),

            Err(err) => println!(
                r#"{{ "alt": "error", "class": "error", "percentage": 0, "tooltip": "{err}" }}"#
            ),
        }

        thread::sleep(INTERVAL);
    }
}
