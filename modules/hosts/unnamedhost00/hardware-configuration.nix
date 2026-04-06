{
  flake.modules.darwin.hostUnnamedhost00 = { config, lib, pkgs, modulesPath, ... }:

  {
    nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";
  };
}
