{ config, pkgs, ... }:
{
  stylix = {
    enable = true;

    # Wallpaper
    image = ../themes/Croptic/images/20181014-04-Croptic-Karl_Delandsheere.jpg;

    # As we do not declare base16Scheme,
    # stylix will generate one from the wallpaper.
    # This tells stylix to go for a darker palette.
    polarity = "dark";

    # Fonts
    # fonts = {
    #   serif = {
    #     package = pkgs.dejavu_fonts;
    #     name = "DejaVu Serif";
    #   };

    #   sansSerif = {
    #     package = pkgs.dejavu_fonts;
    #     name = "DejaVu Sans";
    #   };

    #   monospace = {
    #     package = pkgs.dejavu_fonts;
    #     name = "DejaVu Sans Mono";
    #   };

    #   emoji = {
    #     package = pkgs.noto-fonts-emoji;
    #     name = "Noto Color Emoji";
    #   };
    # };

    autoEnable = false;
  };
}
