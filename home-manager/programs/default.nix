{ osConfig, lib, ... }:
{
  imports =
    [ ./cli ]
    ++ lib.lists.optionals ( osConfig.gui.enable ) [ ./gui ];

  nixpkgs.config.allowUnfree = true;
}
