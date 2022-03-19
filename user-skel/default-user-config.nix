# To test (from project root dir):
# nix eval '(import ./user-skel/default-user-config.nix) {lib = (import <nixpkgs/nixos> {}).pkgs.lib; username = "xxx";}'

{ lib
, username
, autologin ? false
,
}:

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

    # Create a default nixpkgs config
    mkdir -pv /home/${username}/.config/nixpkgs
    chown ${username} /home/${username}/.config/nixpkgs
    if [ ! -f /home/${username}/.config/nixpkgs/config.nix ]; then
      echo '{ allowUnfree = true; }' > /home/${username}/.config/nixpkgs/config.nix
      chown ${username} /home/${username}/.config/nixpkgs/config.nix
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
