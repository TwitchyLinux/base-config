{ self, super }:

super.rustPlatform.buildRustPackage rec {
  pname = "twl-configurator";
  version = "06a33486c550bed9a5f68d242899c65a0863fb36";

  nativeBuildInputs = [ super.pkg-config ];
  buildInputs = [ super.gtk3 super.dbus ];

  src = super.fetchFromGitHub {
    owner = "twitchylinux";
    repo = "configurator";
    rev = version;
    sha256 = "0dg9inn5hqvkjjrjm802xf0kjz19npm0pw0n6yv655q502501j6a";
  };

  cargoSha256 = "148lw3w7z0cv7s29kl1vz8ci1j46d6ll6bbp42dyzsdhi1q62l1i"; # super.lib.fakeSha256;

  meta = with super.lib; {
    description = "Graphical installer for twitchylinux.";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
