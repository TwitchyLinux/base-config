{ self, super }:

super.rustPlatform.buildRustPackage rec {
  pname = "twl-configurator";
  version = "1daa6a5e121f6220c7ab0f12ff499854988635ed";

  nativeBuildInputs = [ super.pkg-config ];
  buildInputs = [ super.gtk3 ];

  src = super.fetchFromGitHub {
    owner = "twitchylinux";
    repo = "configurator";
    rev = version;
    sha256 = "1vhrd8ymn737bawg7wxzbvbrmkc5dzlwm32fd1ipwkvmbq6y5c44";
  };

  cargoSha256 = "0i4y8m0q6vkk8x3z3ficph0hgvi5kl8sipnf7xa2gsvnlrwpy5ii"; # super.lib.fakeSha256;

  meta = with super.lib; {
    description = "Graphical installer for twitchylinux.";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
