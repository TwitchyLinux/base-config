{ self, super }:
super.stdenv.mkDerivation rec {
  pname = "twl-desktop-shortcuts";
  version = "0.0.1";

  src = ./resources/shortcut-template;

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/share/applications/

    cp $src $out/share/applications/shutdown.desktop
    sed -i 's/CMD/systemctl poweroff -i/g'            $out/share/applications/shutdown.desktop
    sed -i 's/NAME/Shutdown/g'                        $out/share/applications/shutdown.desktop
    sed -i 's/ICON/system-shutdown/g'                 $out/share/applications/shutdown.desktop

    cp $src $out/share/applications/reboot.desktop
    sed -i 's/CMD/systemctl reboot/g'                 $out/share/applications/reboot.desktop
    sed -i 's/NAME/Reboot/g'                          $out/share/applications/reboot.desktop
    sed -i 's/ICON/system-reboot\nKeywords=restart/g' $out/share/applications/reboot.desktop

    cp $src $out/share/applications/display-settings.desktop
    sed -i 's/CMD/configurator display/g'             $out/share/applications/display-settings.desktop
    sed -i 's/NAME/Display settings/g'                $out/share/applications/display-settings.desktop
    sed -i 's/ICON/video-display/g'                   $out/share/applications/display-settings.desktop

    cp $src $out/share/applications/screenshot-selection.desktop
    sed -i "s/CMD/bash -c 'CMD'/g"                    $out/share/applications/screenshot-selection.desktop
    sed -i 's/CMD/grim -g "$(slurp)"/g'               $out/share/applications/screenshot-selection.desktop
    sed -i 's/NAME/Screenshot (to file)/g'            $out/share/applications/screenshot-selection.desktop
    sed -i 's/ICON/camera-web/g'                      $out/share/applications/screenshot-selection.desktop

    cp $src $out/share/applications/screenshot-clipboard.desktop
    sed -i "s/CMD/bash -c 'CMD'/g"                                  $out/share/applications/screenshot-clipboard.desktop
    sed -i 's#CMD#grim -g "$(slurp)" - | wl-copy -t image/png#g'    $out/share/applications/screenshot-clipboard.desktop
    sed -i 's/NAME/Screenshot (to clipboard)/g'                     $out/share/applications/screenshot-clipboard.desktop
    sed -i 's/ICON/camera-web/g'                                    $out/share/applications/screenshot-clipboard.desktop
  '';
}
