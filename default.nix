{ config, pkgs, boot, lib, ... }:
let
  cfg = config.twl;

in
{
  imports = [
    <nixpkgs/nixos/modules/profiles/all-hardware.nix>
    <nixpkgs/nixos/modules/hardware/all-firmware.nix>

    ./software.nix
    ./auto-updates.nix
  ];

  options.twl = {
    installer = lib.mkEnableOption "build installer";
  };


  config = {
    nixpkgs.overlays = [ (import ./overlays.nix) ];
    # Boot
    boot.loader.grub.enable = false;
    boot.loader.systemd-boot.enable = true;
    boot.postBootCommands = ''
      # On the first boot do some maintenance tasks
      if [ -f /nix-path-registration ]; then
        ${config.nix.package.out}/bin/nix-store --load-db < /nix-path-registration
        touch /etc/NIXOS
        ${config.nix.package.out}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system
        rm -f /nix-path-registration
      fi
    '';

    # Basic localization
    console = lib.mkDefault {
      keyMap = "us";
    };
    environment.etc.inputrc = {
      mode = "0644";
      source = pkgs.copyPathToStore ./resources/inputrc;
    };

    # Fonts
    fonts.fontDir.enable = true;
    fonts.fonts = with pkgs; [
      freefont_ttf
      liberation_ttf
      source-code-pro
      font-awesome_4
    ];

    nixpkgs.config.allowUnfree = true;
    hardware.enableRedistributableFirmware = true;

    # Networking
    networking.networkmanager.enable = true;

    # Bluetooth
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    # Backlight
    programs.light.enable = true;

    # Users / access control
    security.sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };

    documentation.enable = lib.mkForce true;
    documentation.man.enable = lib.mkForce true;
    documentation.dev.enable = lib.mkForce true;
    documentation.nixos.enable = lib.mkForce true;


    # Random extra hardware
    services.udev.extraRules = ''
    # Baofeng DMR radio
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="666"
    # HackRF devices
    ATTR{idVendor}=="1d50", ATTR{idProduct}=="604b", SYMLINK+="hackrf-jawbreaker-%k", MODE="660", GROUP="users"
    ATTR{idVendor}=="1d50", ATTR{idProduct}=="6089", SYMLINK+="hackrf-one-%k", MODE="660", GROUP="users"
    ATTR{idVendor}=="1d50", ATTR{idProduct}=="cc15", SYMLINK+="rad1o-%k", MODE="660", GROUP="users"
    ATTR{idVendor}=="1fc9", ATTR{idProduct}=="000c", SYMLINK+="nxp-dfu-%k", MODE="660", GROUP="users"
    '';
  };
}
