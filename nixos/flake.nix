{
  description = "int03e NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixvim,
      noctalia,
      nix-index-database,
      ...
    }@inputs:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hardware-configuration.nix
          ./modules/boot-hardware.nix
          ./modules/desktop.nix
          ./modules/services.nix
          ./modules/programs.nix
          ./modules/user.nix

          nix-index-database.nixosModules.nix-index
          {
            programs.nix-index-database.comma.enable = true;
          }
        ];
      };
    };
}
