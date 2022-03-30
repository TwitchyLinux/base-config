  import <nixpkgs/nixos/tests/make-test-python.nix> ({ pkgs, lib }: with lib;
    rec {
      name = "sway";

      common =
        { ... }:
          {
            imports = [ ../default.nix ];
            config.twl.installer = false;
            config.environment.etc = {
              "twl-base/resources/sway.config" = {
                text = (builtins.readFile ../resources/sway.config);
                mode = "0755";
              };
              "twl-base/resources/twitchy_background.png" = {
                source = ../resources/twitchy_background.png;
                mode = "0755";
              };
            };
          };

      nodes.sway =
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
          services.getty.autologinUser = "xxx";

          virtualisation.qemu.options = [ "-vga none -device virtio-gpu-pci" ];
          environment.variables = {
            "SWAYSOCK" = "/tmp/sway-ipc.sock";
            "WLR_RENDERER_ALLOW_SOFTWARE" = "1";
          };
        };

      enableOCR = true;

      testScript = ''
        import json, time
        sway.wait_for_unit("multi-user.target")
        sway.wait_for_file("/run/user/1000/wayland-1")
        sway.wait_for_file("/tmp/sway-ipc.sock")
        time.sleep(1)

        # Test the configurator & its desktop shortcut
        sway.succeed(
          "su - xxx -c 'swaymsg exec configurator display'"
        )
        machine.wait_for_text("Configure display")
        outputs = json.loads(sway.execute( "su - xxx -c 'swaymsg -t get_outputs'")[1])
        for o in outputs:
          print("output:", o)
          sway.succeed(
            "su - xxx -c 'swaymsg seat seat0 cursor set {} {}'".format(int(o['rect']['width'] / 2), int(o['rect']['height'] / 3))
          )
          sway.succeed("su - xxx -c 'swaymsg seat seat0 cursor press button1'")
          sway.succeed("su - xxx -c 'swaymsg seat seat0 cursor release button1'")
          sway.wait_for_text(o['name'])
        sway.screenshot("configurator")
      '';
    }
  )