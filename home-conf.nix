{ system, nixpkgs, home-manager, ... }:

let
  username = "steve";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    config.xdg.configHome = configHome;
  };

in
{
  main = home-manager.lib.homeManagerConfiguration rec {
    inherit pkgs system username homeDirectory;

    stateVersion = "21.05";
    configuration = import ./home.nix {
      inherit pkgs;
      inherit (pkgs) config lib stdenv;
    };
  };
}
