{ self, super }:

super.rustPlatform.buildRustPackage rec {
  pname = "twl-configurator";
  version = "08e3691b37adec6d9eca71da07e4eb097a811f93";

  nativeBuildInputs = [ super.pkg-config ];
  buildInputs = [ super.gtk3 ];

  src = super.fetchFromGitHub {
    owner = "twitchylinux";
    repo = "configurator";
    rev = version;
    sha256 = "1kv0lblyw8r4aybj1x0z0bbfydpjd496d10cnanx6hzr3dvdmhbq";
  };

  cargoSha256 = "07mis4538wc27f7bxyqwdhgfs42php41lr9bgd3hvgv64fv2nr5f";# super.lib.fakeSha256;

  meta = with super.lib; {
    description = "Graphical installer for twitchylinux.";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
