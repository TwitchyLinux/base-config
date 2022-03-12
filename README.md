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