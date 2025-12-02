{ config, osConfig, inputs, pkgs, ... }: let
  configDir   = "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/config";
  # configDir   = ./home-manager/config;

  mkConfigSet = paths:
    let
      # List each group of config paths
      configLists = map (group:
        let names = builtins.attrNames (builtins.readDir "${configDir}/${group}");
        in  map (n: { name = n; value = "${group}/${n}"; }) names
      ) paths;

      # Flatten the lists, turn them to an attrset so there are no duplicates
      # if a same config is both in everywhere AND in per-host/hostname,
      # the per-host/hostname one prevails as the most specific one
      configSet = builtins.listToAttrs (builtins.concatLists configLists);
    in
      configSet;
in
{
  config = {
    # Automatically import all pertinent configs
    # ------------------------------------------
    xdg.configFile = builtins.mapAttrs (name: subpath: {
      source    = config.lib.file.mkOutOfStoreSymlink "${configDir}/${subpath}";
      recursive = true;
    }) (mkConfigSet [ "everywhere" "per-host/${osConfig.nouveauxParadigmes.hostname}" ]);
  };
}
