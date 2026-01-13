{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    sops-nix.url = "github:Mic92/sops-nix";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-doom-emacs-unstraightened.url = "github:marienz/nix-doom-emacs-unstraightened";
    # Optional, to download less. Neither the module nor the overlay uses this input.
    nix-doom-emacs-unstraightened.inputs.nixpkgs.follows = "";
  };

  outputs = { self, nixpkgs, disko, nixos-facter-modules, sops-nix, determinate, ... }@inputs: 
    {
      nixosConfigurations.server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/server/server.nix
          disko.nixosModules.disko
          nixos-facter-modules.nixosModules.facter
          { config.facter.reportPath = ./hosts/server/facter.json; }
          sops-nix.nixosModules.sops
          determinate.nixosModules.default
        ];
      };
        nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/laptop/laptop.nix
          disko.nixosModules.disko
          nixos-facter-modules.nixosModules.facter
          { config.facter.reportPath = ./hosts/laptop/facter.json; }
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
          determinate.nixosModules.default
        ];
      };
        nixosConfigurations.workstation = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/workstation/workstation.nix
          disko.nixosModules.disko
          nixos-facter-modules.nixosModules.facter
          { config.facter.reportPath = ./hosts/workstation/facter.json; }
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
          determinate.nixosModules.default
        ];
      };
    };
}
