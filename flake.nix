{
  description = "Trying to make NixOS daily drivable";
  inputs = {
    #    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-26.05";


    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      #      inputs.quickshell.follows = "quickshell"; # Use same quickshell version
    };
  };


  outputs = inputs@ { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          #./noctalia.nix
          inputs.noctalia.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.coffee = import ./home.nix;
            home-manager.backupFileExtension = "backup";
          }
        ];
      };
    };
}
#{
#  description = "Trying to make NixOS daily drivable";
#  inputs = {
#    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
#    home-manager.url = "github:nix-community/home-manager/release-26.05";
#    home-manager.inputs.nixpkgs.follows = "nixpkgs";
#  };
#  outputs = { self, nixpkgs, home-manager, ... }:
#    let
#      system = "x86_64-linux";
#    in
#    {
#      nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
#        inherit system;
#        modules = [
#          ./configuration.nix
#          home-manager.nixosModules.home-manager
#          {
#            home-manager.useGlobalPkgs = true;
#            home-manager.useUserPackages = true;
#            home-manager.users.coffee = import ./home.nix;
#            home-manager.backupFileExtension = "backup";
#          }
#        ];
#      };
#    };
#}
