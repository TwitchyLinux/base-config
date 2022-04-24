# To test (from project root dir):
# nix eval '(import ./user-skel/default-user-config.nix) {lib = (import <nixpkgs/nixos> {}).pkgs.lib; username = "xxx";}'

{ lib
, username
, autologin ? false
,
}:
let
 sway-conf-files = lib.concatStringsSep "\n" (map (fname: ''
      if [ ! -e /home/${username}/.config/sway/twl/${fname} ]; then
        touch ${username} /home/${username}/.config/sway/twl/${fname}
        chown ${username} /home/${username}/.config/sway/twl/${fname}
        chmod 0644 /home/${username}/.config/sway/twl/${fname}
      fi
    '')
    [ "displays" "power" ]
  );


in
  lib.stringAfter [ "users" "groups" ] (
    ''
      # Create a default sway config
      if [ ! -e /home/${username}/.config/sway ]; then
        mkdir -pv /home/${username}/.config/sway
        cp -v /etc/twl-base/resources/sway.config /home/${username}/.config/sway/config
        chown ${username} /home/${username}/.config
        chown ${username} /home/${username}/.config/sway
        chown ${username} /home/${username}/.config/sway/config
        chmod 0644 /home/${username}/.config/sway/config
      fi

      # Make the directory for configurator-generated config
      if [ ! -d /home/${username}/.config/sway/twl ]; then
        mkdir -pv /home/${username}/.config/sway/twl
        chown ${username} /home/${username}/.config/sway/twl
      fi
      # Make empty configurator config files if they dont exist
      ${sway-conf-files}
      # Special case on configuration files: default keybindings
      if [ ! -e /home/${username}/.config/sway/twl/keys ]; then
        cp -v /etc/twl-base/resources/sway-default-keybindings.config /home/${username}/.config/sway/twl/keys
        chown ${username} /home/${username}/.config/sway/twl/keys
        chmod 0644 /home/${username}/.config/sway/twl/keys
      fi

      # Create a default nixpkgs config
      mkdir -pv /home/${username}/.config/nixpkgs
      chown ${username} /home/${username}/.config/nixpkgs
      if [ ! -f /home/${username}/.config/nixpkgs/config.nix ]; then
        echo '{ allowUnfree = true; }' > /home/${username}/.config/nixpkgs/config.nix
        chown ${username} /home/${username}/.config/nixpkgs/config.nix
      fi

      # Create a default bashrc
      if [ ! -f /home/${username}/.bashrc ]; then
        echo 'export HISTCONTROL=ignoredups:erasedups' > /home/${username}/.bashrc
        echo 'export HISTSIZE=100000' >> /home/${username}/.bashrc
        echo 'export HISTFILESIZE=100000' >> /home/${username}/.bashrc
        echo 'shopt -s histappend' >> /home/${username}/.bashrc
        chown ${username} /home/${username}/.bashrc
      fi
    '' + lib.optionalString autologin
      ''
        if [ ! -f /home/${username}/.bash_login ]; then
          echo 'if [[ $(tty) == "/dev/tty1" ]]; then' >> /home/${username}/.bash_login
          echo '  sleep 2 && startsway' >> /home/${username}/.bash_login
          echo 'fi' >> /home/${username}/.bash_login
          chown ${username} /home/${username}/.bash_login
        fi
      ''
  )
