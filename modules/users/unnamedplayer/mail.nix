###############################################################################
#
# Unnamedplayer (that's me), I'm the main user on this system.
#
###############################################################################

{ inputs, self, ... }: let
  username = "unnamedplayer";
  homeDirectory = "/home/${username}";
in
{
  flake.homeModules.${username} = { config, pkgs, osConfig, lib, inputs, ... }: let
    cfg = osConfig.nouveauxParadigmes;
  in
  {
    config = {
      accounts.email = let
        passwordCmd = name: "cat /run/agenix/auth/bw | bw get password Mail/${name}";

        defaultSignature = ''
          #-- <b>¯\_(ツ)_/¯</b> --#
          <b>Karl Delandsheere</b>
          <a href="https://shotbykarl.be">Photographie</a> / <a href="https://karl.delandsheere.be/webdev/">Développement web & infographie</a> / <a href="https://longrushtranquille.be">Impression 3D</a>
          --
          Liège, Belgique
          Tel/Signal : <a href="tel:+32498139866">+32 498 13 98 66</a>
        '';
      in
      { # @todo Shouldn't I move this to secrets?
        # maildirBasePath = "/persist/data/mail";

        accounts."karl_at_delandsheere_be" = let
          userName = "karl@delandsheere.be";
          passwordCommand = passwordCmd userName;
          signature = defaultSignature;
        in
        {
          inherit userName passwordCommand;

          primary = true;

          name = "Karl Delandsheere";
          realName = "Karl Delandsheere";
          address = userName;
          signature = {
            showSignature = "append";
            text = signature;
          };

          flavor = "migadu.com";

          aerc.enable = config.home.programs.aerc.enable;
          thunderbird.enable = config.home.programs.thunderbird.enable;
        };

        accounts."karl_at_nouveaux-paradigmes_be" = let
          userName = "karl@nouveaux-paradigmes.be";
          passwordCommand = passwordCmd userName;
          signature = defaultSignature;
        in
        {
          inherit userName passwordCommand;

          name = "Nouveaux paradigmes";
          realName = "Karl Delandsheere";
          address = userName;
          signature = {
            showSignature = "append";
            text = signature;
          };

          flavor = "migadu.com";

          aerc.enable = config.home.programs.aerc.enable;
          thunderbird.enable = config.home.programs.thunderbird.enable;
        };

        accounts."expo_at_ventrecontent_be" = let
          host = "mail.ventrecontent.be";
          userName = "expo@ventrecontent.be";
          passwordCommand = passwordCmd userName;
          signature = ''
            --
            <b>Karl pour Ventre Content<a href="https://ventrecontent.be">Ventre Content</a></b>
            --
            Tel/Signal : <a href="tel:+32498139866">+32 498 13 98 66</a>
          '';
        in
        {
          inherit userName passwordCommand;
          
          name = "Expo @ Ventre Content";
          realName = "Ventre Content";
          address = userName;
          signature = {
            showSignature = "append";
            text = signature;
          };

          imap.host = host;
          smtp.host = host;

          aerc.enable = config.home.programs.aerc.enable;
          thunderbird.enable = config.home.programs.thunderbird.enable;
        };
      };
    };
  };
}
