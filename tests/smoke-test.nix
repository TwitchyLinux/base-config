  import <nixpkgs/nixos/tests/make-test-python.nix> ({ pkgs, lib }: with lib;
    rec {
      name = "smoke-test";

      common =
        { ... }:
          {
            imports = [ ../default.nix ];
            config.twl.installer = false;
            config.environment.etc = {
              "twl-base/resources/sway.config" = {
                source = ../resources/sway.config;
                mode = "0755";
              };
            };
          };

      nodes.userskel =
        { pkgs, ... }:
        { imports = [ common ];
          users.users.xxx = {
            isNormalUser = true;
            extraGroups = [ "wheel" "networkmanager" "video" ];
          };
          system.activationScripts.etc = import ../user-skel/default-user-config.nix {
            lib = lib;
            username = "xxx";
            autologin = true;
          };
        };

      testScript = ''
        userskel.wait_for_unit("multi-user.target")
        userskel.wait_for_file("/home/xxx/.config/sway/config")

        assert "xxx:x:1000" in userskel.succeed(
            "cat /etc/passwd | grep xxx"
        )

        userskel.wait_for_file("/etc/systemd/system/nixenv-upgrade.service")
      '';
    }
  )