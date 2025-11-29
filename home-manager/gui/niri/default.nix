{ config, osConfig, inputs, pkgs, ... }: let
in
{
  imports = [
    inputs.niri.homeModules.niri
  ];

  config = {
    programs.niri.enable = true;


    home = {
      file.".config/niri/config.kdl".source =
        config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/wm/niri/config.kdl";

      sessionVariables = {
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_DESKTOP = "niri";
      };

      packages = with pkgs; [
        (writeShellScriptBin "launch-dailies" ''
          # Startup script to launch the TUI apps I use daily
          # -------------------------------------------------
          ghostty --title="aerc" -e aerc &
          ghostty --title="calcurse" -e calcurse &
          ghostty --title="gurk" -e gurk &
          ghostty --title="iamb" -e iamb &

          # Give some time for everything to settle
          sleep 2

          # Order the windows in columns
          niri msg action focus-workspace "daily" &&
          niri msg action focus-column-left && # From column 4 to column 3
          niri msg action consume-window-into-column && # Merge columns 3 and 4
          niri msg action focus-column-left && # From column 3 to 2
          niri msg action focus-column-left && # From column 2 to 1
          niri msg action consume-window-into-column && # Merge columns 1 and 2
          niri msg action focus-column-left # Recenter by focussing on column 1
        '')
      ];
    };


    # @todo make this shell agnostic
    programs.zsh.profileExtra = ''
      # Check if the terminal is tty1 so we only autolaunch niri on that one
      if [[ "$(tty)" == "/dev/tty1" ]]; then
        exec niri --session
      fi
    '';
  };
}
