{
  # Configs layout following https://gvolpe.com/blog/nix-flakes/

  description = "system configuration flake";

  inputs = {
    # Replace this with any nixpkgs revision you want to use.
    # See a list of potential revisions at
    # https://github.com/NixOS/nixpkgs/branches/active
    nixpkgs.url = "nixpkgs/release-22.05";

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      nixConf = pkgs: {
        environment.systemPackages = [ pkgs.git ];
        nix = {
          package = pkgs.nixFlakes;
          extraOptions = ''
            experimental-features = nix-command flakes
          '';
          autoOptimiseStore = true;
          gc = {
            automatic = true;
            dates = "weekly";
          };
        };
      };
    in
    {
      ## Replace machineName with your desired hostname.
      #nixosConfigurations.mail = nixpkgs.lib.nixosSystem rec {
      #  system = "x86_64-linux";

      #  modules = [
      #    (nixConf nixpkgs.legacyPackages.${system})
      #    ./configuration.nix
      #  ];
      #};
      homeConfigurations = (
        import ./home-conf.nix {
          inherit system nixpkgs home-manager;
        }
      );

      nixosConfigurations = (
        import ./nixos-conf.nix {
          inherit (nixpkgs) lib;
          inherit inputs system;
        }
      );

    };
}
