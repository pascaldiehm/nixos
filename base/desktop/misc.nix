{ lib, pkgs, ... }: {
  boot.kernel.sysctl."kernel.sysrq" = 1;
  security.rtkit.enable = true;
  services.logind.settings.Login.HandlePowerKey = "suspend";

  home-manager.users.pascal.programs.git.signing = {
    key = "E85EB0566C779A2F";
    signByDefault = true;
  };

  systemd.services.docker.preStop = ''
    ${lib.getExe pkgs.docker} container ls --all --quiet | xargs --no-run-if-empty ${lib.getExe pkgs.docker} container rm --force
  '';
}
