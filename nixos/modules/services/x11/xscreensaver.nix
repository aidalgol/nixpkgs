{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xscreensaver;
in
{
  options.services.xscreensaver = {
    enable = mkEnableOption "xscreensaver user service";

    package = mkOption {
      type = types.package;
      default = pkgs.xscreensaver;
      defaultText = literalExpression "pkgs.xscreensaver";
      description = "Which xscreensaver package to use.";
    };
  };

  config = mkIf cfg.enable {
    # Make xscreensaver-auth setuid root so that it can (try to) prevent the OOM
    # killer from unlocking the screen.
    security.wrappers.xscreensaver-auth = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.xscreensaver}/libexec/xscreensaver/xscreensaver-auth";
    };

    systemd.user.services.xscreensaver = {
      enable = true;
      description = "XScreenSaver";
      after = [ "graphical-session-pre.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      path = [ cfg.package ];
      environment = {
        DEFAULT_PATH_PREFIX = config.security.wrapperDir;
      };
      serviceConfig.ExecStart = "${cfg.package}/bin/xscreensaver -no-splash";
    };
  };

  meta.maintainers = with maintainers; [ aidalgol ];
}
