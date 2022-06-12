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

  mkHome = conf: (
    home-manager.lib.homeManagerConfiguration rec {
      inherit pkgs system username homeDirectory;

      stateVersion = "21.05";
      configuration = conf;
    });

  conf = import ./display.nix {
    inherit pkgs;
    inherit (pkgs) config lib stdenv;
  };
in
{
  main = mkHome conf;
}
