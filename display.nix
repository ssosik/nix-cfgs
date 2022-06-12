{ config, lib, pkgs, stdenv, ... }:

let
  base = pkgs.callPackage ./home.nix { inherit config lib pkgs stdenv; };

in
{
  imports = [
    ./home.nix
  ];

  home.packages = base.home.packages ;
}
