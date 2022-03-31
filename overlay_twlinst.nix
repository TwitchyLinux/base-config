{ self, super }:

super.buildGoModule rec {
  name = "twlinst";
  version = "759bad32b97f972949a627932c0b8b8d807f83a2";

  src = super.fetchFromGitHub {
    owner = "twitchylinux";
    repo = "twlinst";
    rev = "${version}";
    sha256 = "12pmnbkibvmb96qj4b7p7zb9lhjw8y4lbmzhgigfm8hdhls9nviw"; # use nix-prefetch-git
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
