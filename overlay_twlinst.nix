{ self, super }:

super.buildGoModule rec {
  name = "twlinst";
  version = "e6d8e49177218c86133c43048606c74c122b9585";

  src = super.fetchFromGitHub {
    owner = "twitchylinux";
    repo = "twlinst";
    rev = "${version}";
    sha256 = "06lzf7sqm2f1aq0cm6j7bjxyy53xihrq00r1gc4vllrwssnyi7h8"; # use nix-prefetch-git
  };

  vendorSha256 = "sha256-FKB3YiM/zkkW5olfnaCw4AYI7YvcpvLyLSP6xHMd5mY=";

  nativeBuildInputs = [ super.pkg-config ];
  buildInputs = [ super.gtk3 ];

  postInstall = ''
    cp -v layout.glade $out/twlinst.glade
  '';

  meta = with super.lib; {
    description = "Graphical installer for twitchylinux.";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
