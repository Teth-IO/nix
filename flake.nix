{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    sops-nix.url = "github:Mic92/sops-nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.dgop.follows = "dgop";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, disko, nixos-facter-modules, sops-nix, ... }@inputs: 
    {
      nixosConfigurations.server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./server/server.nix
          disko.nixosModules.disko
          nixos-facter-modules.nixosModules.facter
          { config.facter.reportPath = ./server/facter.json; }
          sops-nix.nixosModules.sops
        ];
      };
        nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./laptop/laptop.nix
          disko.nixosModules.disko
          nixos-facter-modules.nixosModules.facter
          { config.facter.reportPath = ./laptop/facter.json; }
          inputs.dankMaterialShell.nixosModules.greeter
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit inputs;
              };
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }
        ];
      };
    };
}