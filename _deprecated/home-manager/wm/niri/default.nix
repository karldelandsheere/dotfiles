{ config, osConfig, inputs, pkgs, ... }: let
in
{
  imports = [
    inputs.niri.homeModules.niri
    inputs.noctalia.homeModules.default
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


    #########################################################



        # configure options
    programs.noctalia-shell = {
      enable = true;
      # settings = {
      #   # configure noctalia here; defaults will
      #   # be deep merged with these attributes.
      #   bar = {
      #     density = "compact";
      #     position = "right";
      #     showCapsule = false;
      #     widgets = {
      #       left = [
      #         {
      #           id = "SidePanelToggle";
      #           useDistroLogo = true;
      #         }
      #         {
      #           id = "WiFi";
      #         }
      #         {
      #           id = "Bluetooth";
      #         }
      #       ];
      #       center = [
      #         {
      #           hideUnoccupied = false;
      #           id = "Workspace";
      #           labelMode = "none";
      #         }
      #       ];
      #       right = [
      #         {
      #           alwaysShowPercentage = false;
      #           id = "Battery";
      #           warningThreshold = 30;
      #         }
      #         {
      #           formatHorizontal = "HH:mm";
      #           formatVertical = "HH mm";
      #           id = "Clock";
      #           useMonospacedFont = true;
      #           usePrimaryColor = true;
      #         }
      #       ];
      #     };
      #   };
      #   colorSchemes.predefinedScheme = "Monochrome";
      #   general = {
      #     avatarImage = "/home/drfoobar/.face";
      #     radiusRatio = 0.2;
      #   };
      #   location = {
      #     monthBeforeDay = true;
      #     name = "Marseille, France";
      #   };
      # };
      # # this may also be a string or a path to a JSON file,
      # # but in this case must include *all* settings.
    };









    #########################################################
    

    # @todo make this shell agnostic
    programs.zsh.profileExtra = ''
      # Check if the terminal is tty1 so we only autolaunch niri on that one
      if [[ "$(tty)" == "/dev/tty1" ]]; then
        exec niri --session
      fi
    '';
  };
}
