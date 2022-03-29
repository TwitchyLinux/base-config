{ self, super }:

super.rustPlatform.buildRustPackage rec {
  pname = "twl-configurator";
  version = "8eba8a81acd25e732ca1674100e06f144b0754b3";

  nativeBuildInputs = [ super.pkg-config ];
  buildInputs = [ super.gtk3 ];

  src = super.fetchFromGitHub {
    owner = "twitchylinux";
    repo = "configurator";
    rev = version;
    sha256 = "1yil2wivhzp14kr817dzg6xk15r1cyxlj5cj9viwnyrnhy6df2iz";
  };

  cargoSha256 = "1hl7qgkkdnrlhlm3jhdjmw5kg32b1inp75d3j5xbyzyvgd3i51bv";# super.lib.fakeSha256;

  meta = with super.lib; {
    description = "Graphical installer for twitchylinux.";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
