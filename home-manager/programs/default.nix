{ osConfig, lib, ... }:
{
  imports =
    [ ./cli ]
    ++ lib.lists.optionals ( osConfig.nouveauxParadigmes.gui.enable ) [ ./gui ];

  nixpkgs.config.allowUnfree = true;
}
