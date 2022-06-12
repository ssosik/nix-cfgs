{ lib, inputs, system, ... }:

{
  #dell-xps = lib.nixosSystem {
  #  inherit system;
  #  specialArgs = { inherit inputs; };
  #  modules = [
  #    ../system/machine/dell-xps
  #    ../system/configuration.nix
  #  ];
  #};

  mail = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ./hardware-configuration.nix
      ./configuration.nix
    ];
  };
}
