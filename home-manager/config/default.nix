{ config, osConfig, inputs, pkgs, ... }: let
  configDir   = "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/config";
  hostname    = "${osConfig.nouveauxParadigmes.hostname}";
  listConfigs = parent: map(name: "${parent}/${name}")
          (builtins.attrNames (builtins.readDir "${configDir}/${parent}"));
  mkSymlink   = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  config = {

    xdg.configFile = builtins.mapAttrs (name: subpath: {
      source    = mkSymlink "${configDir}/${subpath}";
      recursive = true;
    }) listConfigs "everywhere" ++ listConfigs "per-host/${hostname}";

    # xdg.configFile = builtins.mapAttrs
    #   (name: subpath: {
    #     source = mkSymlink "${configFiles}/${subpath}";
    #     recursive = true;
    #   })
    #   configs;

    # configs = builtins.attrNames (builtins.readDir "${configFiles}/everywhere")
    #        ++ builtins.attrNames (builtins.readDir "${configFiles}/per-host/${hostname}");


# nix eval --impure --expr '
# let
#   mkEntries = parent: dir:
#     map (c: "${c}:${parent}/${c}")
#       (builtins.attrNames (builtins.readDir dir));
# in
#   mkEntries "everywhere" "/etc/nixos/home-manager/config/everywhere"
#   ++
#   mkEntries "q3dm10" "/etc/nixos/home-manager/config/per-host/q3dm10"
# '



  };
}
