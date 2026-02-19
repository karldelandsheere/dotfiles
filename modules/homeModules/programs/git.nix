###############################################################################
#
# Git, default config for common use under this system
#
# User related parameters such as username, email and signing key
#   should be in the user's config
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.git = { config, ... }:
  {
    config = {
      programs.git = {
        enable = true;
        signing.signByDefault = true;
      };

      home.shellAliases = {
        # Git shortcuts for the lazy asses like me
        ga    = "git add";
        gaa   = "git add --all";
        gaacm = "git add --all && git commit -S -m";
        gb    = "git branch";
        gc    = "git commit -S";
        gch   = "git checkout";
        gchb  = "git checkout -b";
        gcl   = "git clone";
        gcm   = "git commit -S -m";
        gd    = "git diff";
        gm    = "git merge";
        gpl   = "git pull";
        gplo  = "git pull origin";
        gps   = "git push";
        gpso  = "git push origin";
        gs    = "git status";
      };
    };
  };
}
