###############################################################################
#
# Bottom, a process/system monitor in the tty
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.bottom = { config, ... }:
  {
    config = {
      programs.bottom = {
        enable = true;
        settings = {
          styles = let
            color1 = "#a6e3a1";
            color2 = "#f38ba8";
            color3 = "#f9e2af";
            color4 = "#f5e0dc";
            color5 = "#eba0ac";
            color6 = "#fab387";
            color7 = "#74c7ec";
            color8 = "#cba6f7";
            color9 = "#89dceb";
            color10 = "#1e1e2e";
            color11 = "#f5c2e7";
            color12 = "#11111b";
            color13 = "#cdd6f4";
            color14 = "#f2cdcd";
          in {
            battery = {
              high_battery_color = color1;
              low_battery_color = color2;
              medium_battery_color = color3;
            };
            cpu = {
              all_entry_color = color4;
              avg_entry_color = color5;
              cpu_core_colors = [ color2 color6 color3 color1 color7 color8 ];
            };
            graphs = {
              graph_color = color1;
              legend_text = { color = color1; };
            };
            memory = {
              arc_color = color9;
              cache_color = color2;
              gpu_colors = [ color7 color8 color2 color6 color3 color1 ];
              ram_color = color1;
              swap_color = color6;
            };
            network = {
              rx_color = color1;
              tx_color = color2;
              rx_total_color = color9;
              tx_total_color = color1;
            };
            tables = {
              headers = { color = color4; };
            };
            widgets = {
              disabled_text = { color = color10; };
              selected_border_color = color11;
              selected_text = {
                bg_color = color8;
                color = color12;
              };
              text = { color = color13; };
              widget_title = { color = color14; };
            };
          };
        };
      };
    };
  };
}
