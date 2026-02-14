###############################################################################
#
# Fastfetch, system information in the tty for the cool kids with aesthetics.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.fastfetch = { config, ... }:
  {
    config = {
      programs.fastfetch = {
        enable = true;
        settings = let
          logoColor1 = "#a6adc8";
          logoColor2 = "#9399b2";
          keyColor = "#f5c2e7";

          sectionTitle = name: " [---- ${name} ----] ";
          sectionEnd = " ────────────────────── ";

          colored = type: { inherit type keyColor; };
        in
        {
          display = {
            constants = [ "─────────────────" ];
            key = { paddingLeft = 2; type = "icon"; };
            separator = "  ";
          };

          logo = {
            color = { "1" = logoColor1; "2" = logoColor2; };
            height = 20;
            padding = { left = 2; right = 2; };
            width = 25;
          };

          modules = [
            { type = "custom"; format = sectionTitle "Hardware Information"; }
            (colored "host")
            (colored "cpu")
            (colored "gpu")
            (colored "disk")
            (colored "memory")
            (colored "swap")
            (colored "display")
            { type = "custom"; format = sectionEnd; }

            { type = "custom"; format = ""; }

            { type = "custom"; format = sectionTitle "Software Information"; }
            (colored "os")
            (colored "kernel")
            (colored "wm")
            (colored "shell")
            (colored "terminal")
            (colored "font")
            (colored "theme")
            (colored "icons")
            (colored "packages")
            (colored "uptime")
            (colored "locale")
            { type = "custom"; format = sectionEnd; }

            {
              paddingLeft = 2;
              symbol = "circle";
              type = "colors";
            }
          ];
        };
      };
    };
  };
}
