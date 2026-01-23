{ inputs, ... }:
{
  flake =
    let
      inherit (inputs.nixpkgs.lib) nixosSystem mapAttrs;

      mkSystemConfig = { hostname, system,
                         modules ? [], users ? [], ... }: nixosSystem
      {
        inherit system;
        modules = [ ./hosts/${hostname} ] ++ modules;

        specialArgs = {
          inherit inputs;
          users = [ "unnamedplayer" ] ++ users;
        };
      };
    in
    {
      # Declare the different hosts configs
      nixosConfigurations = mapAttrs (hostname: config:
        mkSystemConfig ( { inherit hostname; } // config ) )
        {
          "q3dm10" = { system = "x86_64-linux"; };
          "q3dm11" = { system = "i686-linux"; };
          "utm"    = { };
        };
    };

  config = {
    systems = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
}
