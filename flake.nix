{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    sops-nix.url = "github:Mic92/sops-nix";
    preservation.url = "github:nix-community/preservation";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs = {
        doomdir.url = "./gui/modules/doom.d";
        # Optional, to download less. Neither the module nor the overlay uses this input.
        nixpkgs.follows = "";
      };
    };
    
    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: 
  {
    nixosConfigurations.server = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/server/server.nix
        inputs.disko.nixosModules.disko
        inputs.nixos-facter-modules.nixosModules.facter
        { config.facter.reportPath = ./hosts/server/facter.json; }
        inputs.sops-nix.nixosModules.sops
      ];
    }; 
    nixosConfigurations.server-next = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/server-next/server.nix
        inputs.disko.nixosModules.disko
        inputs.preservation.nixosModules.default
        inputs.nixos-facter-modules.nixosModules.facter
        { config.facter.reportPath = ./hosts/server-next/facter.json; }
        inputs.sops-nix.nixosModules.sops
      ];
    };
    nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/laptop/laptop.nix
        inputs.disko.nixosModules.disko
        inputs.nixos-facter-modules.nixosModules.facter
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
        inputs.auto-cpufreq.nixosModules.default
        inputs.sops-nix.nixosModules.sops
      ];
    };
    nixosConfigurations.workstation = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/workstation/workstation.nix
        inputs.disko.nixosModules.disko
        inputs.nixos-facter-modules.nixosModules.facter
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
        inputs.sops-nix.nixosModules.sops
      ];
    };
  };
}
