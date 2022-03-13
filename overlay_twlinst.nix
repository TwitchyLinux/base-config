{ self, super }:

super.buildGoModule rec {
  name = "twlinst";
  version = "3845b255b672917dc7edc70d3948df3d5446f184";

  src = super.fetchFromGitHub {
    owner = "twitchylinux";
    repo = "twlinst";
    rev = "${version}";
    sha256 = "1d7i8698bn12886w42zc4ah8illwh6kd23nnlmz5i5izna6yivwx"; # use nix-prefetch-git
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
