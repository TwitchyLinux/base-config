# base-config

NixOS module to configure the basics/internals of TwitchyLinux.

The installer will do this automatically, but if you want to use manually:

1. Do a clean checkout of this to `/etc/twl-base`
2. Import the module from your `/etc/nixos/configuration.nix`:

```nix
	imports = [
		../twl-base
	];
```

### TODO list

#### For 0.2

 - [ ] Installer needs 'install finished' pane with reboot button
 - [ ] Installer needs to prompt you to connect to the network
 - [ ] gammastep desktop entry needs to be deleted
 - [ ] nix-env --update automatically
 - [ ] nixos-rebuild switch automatically
 - [ ] idlelock + lock on screen close
 - [ ] Pressing escape exits settings UI's
 - [ ] Key bindings UI

#### Backlog

 - [ ] Installer should show a quickstart when you first use it
 - [ ] Integration with minikernel
 - [ ] Settings UI for network
 - [ ] Settings UI for idlelock
 - [ ] Settings UI for input devices
 - [ ] Store password hash in a shadow nix file
 - [ ] Auto-update nixos-hardware, twl-base
