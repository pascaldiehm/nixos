{ lib, pkgs, ... }: {
  home-manager.users.pascal.programs.git.signing = {
    key = "E85EB0566C779A2F";
    signByDefault = true;
  };

  systemd.services.docker.preStop = ''
    ${lib.getExe pkgs.docker} container ls --all --quiet | xargs --no-run-if-empty ${lib.getExe pkgs.docker} container rm --force
  '';
}
