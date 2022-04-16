{ self, super }:

super.buildGoModule rec {
  name = "twlinst";
  version = "58098a7d7369783a0ec7bc2c1c9b4f6fcc0ed95d";

  src = super.fetchFromGitHub {
    owner = "twitchylinux";
    repo = "twlinst";
    rev = "${version}";
    sha256 = "1w82b7980z1zn3w7ra627dkrc37h7dsxxlikmvjkpqcgfq8n22wi"; # use nix-prefetch-git
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
