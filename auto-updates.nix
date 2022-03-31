{ config, pkgs, boot, lib, ... }:
let
  cfg = config.twl;

in
{
  options.twl = {
    auto-update-userinstalls = lib.mkOption {
      default = true;
      example = true;
      description = "Whether to periodically update user-installed software.";
      type = lib.types.bool;
    };

    auto-update-system = lib.mkOption {
      default = true;
      example = true;
      description = "Whether to periodically rebuild the nixos system.";
      type = lib.types.bool;
    };
  };


  config = {

      nix.gc = {
        automatic = true;
        options = "--delete-older-than 8d";
        dates = "Sat,Mon *-*-* 09:00";
      };
      system.autoUpgrade.enable = cfg.auto-update-system;

    } // lib.mkIf cfg.auto-update-userinstalls {
      systemd.services.nixenv-upgrade = {
        description = "nix-env update";

        restartIfChanged = false;
        unitConfig.X-StopOnRemoval = false;

        serviceConfig.Type = "oneshot";

        environment = config.nix.envVars // {
          inherit (config.environment.sessionVariables) NIX_PATH;
          HOME = "/root";
        } // config.networking.proxy.envVars;

        path = with pkgs; [
          nix
        ];

        script = let
          nix-env  = "${pkgs.nix}/bin/nix-env";
        in
          "${nix-env} --upgrade";

        startAt = "Sat,Wed,Fri *-*-* 17:00";
      };

      systemd.timers.nixenv-upgrade.timerConfig.RandomizedDelaySec = "300";
    };
}
