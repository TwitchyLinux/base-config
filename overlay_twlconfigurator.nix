{ self, super }:

super.rustPlatform.buildRustPackage rec {
  pname = "twl-configurator";
  version = "0310985dbbec7b55e8c223d00b195dc84f7c0c64";

  nativeBuildInputs = [ super.pkg-config ];
  buildInputs = [ super.gtk3 ];

  src = super.fetchFromGitHub {
    owner = "twitchylinux";
    repo = "configurator";
    rev = version;
    sha256 = "06gdxfi2hcxz670f1af1z4r4lqjy8jiaz5zagg28pqkb8qfyq0rm";
  };

  cargoSha256 = "11bybg6p7brcz0fi04q1dsrprpcknl5nblh692bqnzclbb38lngc"; # super.lib.fakeSha256;

  meta = with super.lib; {
    description = "Graphical installer for twitchylinux.";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
