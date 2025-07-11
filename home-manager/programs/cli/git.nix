# Git stuff, including shellAliases
# ---------------------------------
{ config, ... }:
{
  config = {
    programs.git = {
      enable = true;
      userName = "Karl";
      userEmail = "karl@delandsheere.be";

      # @todo implement signing
      # signing = {
      #   key = "";
      #   signByDefault = true;
      # }
    };

    
    # Some shortcuts for lazyasses like me
    # ------------------------------------
    home.shellAliases = {
      ga = "git add";
      gaa = "git add --all";
      gaacm = "git add --all && git commit -m";
      gb = "git branch";
      gc = "git commit";
      gch = "git checkout";
      gchb = "git checkout -b";
      gcl = "git clone";
      gcm = "git commit -m";
      gd = "git diff";
      gm = "git merge";
      gpl = "git pull";
      gplo = "git pull origin";
      gps = "git push";
      gpso = "git push origin";
      gs = "git status";
    };
  };
}
