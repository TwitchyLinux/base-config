{ self, super }:

super.rustPlatform.buildRustPackage rec {
  pname = "twl-configurator";
  version = "b50db049449e2ff71d002bb0a5bb77d18f45c95b";

  nativeBuildInputs = [ super.pkg-config ];
  buildInputs = [ super.gtk3 ];

  src = super.fetchFromGitHub {
    owner = "twitchylinux";
    repo = "configurator";
    rev = version;
    sha256 = "1rpanwvq86mxs84v9h7z8xiv7s7mc8mzg9gfqdi6lvlc8dsi9ayh";
  };

  cargoSha256 = "0b8qj19n9rsbwv13v041hynxkvb15zyd6ynl7g70x0vy2s33a6pn"; # super.lib.fakeSha256;

  meta = with super.lib; {
    description = "Graphical installer for twitchylinux.";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}