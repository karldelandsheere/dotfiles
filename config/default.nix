{ config, osConfig, ... }: let
  mkConfigSet = paths:
    let
      # List each group of config paths
      configLists = map (group:
        # But first, check if the path to the group exists
        let names = if builtins.pathExists ./${group}
              then builtins.attrNames (builtins.readDir ./${group}) else [];
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
      source    = config.lib.file.mkOutOfStoreSymlink ./${subpath};
      recursive = true;
    }) (mkConfigSet [ "per-host/${osConfig.nouveauxParadigmes.hostname}" ]);
    # }) (mkConfigSet [ "everywhere" "per-host/${osConfig.nouveauxParadigmes.hostname}" ]);
  };
}
