# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 20d";
  };

  #mailserver = {
  #  enable = true;
  #  fqdn = "mail.little-fluffy.cloud";
  #  domains = [ "little-fluffy.cloud" "scooby.little-fluffy.cloud" "fluffy-little.cloud" ];

  #  # A list of all login accounts. To create the password hashes, use
  #  # mkpasswd -m sha-512 "super secret password"
  #  loginAccounts = {
  #      "steve@little-fluffy.cloud" = {
  #          hashedPassword = "$6$JP4YI90.Zley$0UOShElbb8qNndanXmlIiq3ASQhRqzwnpoaMopnZL8LWniYHHnbMbQ4cKCU9b4z3HMmGWke0pw0RiJWvTII.P/";

  #          aliases = [
  #              "postmaster@little-fluffy.cloud"
  #          ];

  #          # Make this user the catchAll address for domains little-fluffy.cloud
  #          catchAll = [
  #            "little-fluffy.cloud"
  #            "fluffy-little.cloud"
  #          ];
  #      };

  #      "monit@scooby.little-fluffy.cloud" = {
  #          hashedPassword = "$6$nWSLeS8kRWL$IPpKa9SZlMJ8/Q/hy28BUSIrrODhVSeprc34Mf/Qbr5PrLEB09rRzmBj9hbAlxr6pg.h329nXIHA/HxsuQ7N4.";
  #      };

  #      "alerts@scooby.little-fluffy.cloud" = {
  #          hashedPassword = "$6$VlvVu5JEWEmUEHw$mQtUeYz9FZmO2b1kR9rqe09y/DBwhATM4WdcDKLnn07kQQ5XdozdcQRoGAPoDn4IbBisS5CWLmrw1aa6IUPeh.";
  #      };
  #  };

  #  # Use Let's Encrypt certificates. Note that this needs to set up a stripped
  #  # down nginx and opens port 80.
  #  certificateScheme = 3;

  #  # Enable IMAP and POP3
  #  enableImap = true;
  #  enablePop3 = true;
  #  enableImapSsl = true;
  #  enablePop3Ssl = true;

  #  # Enable the ManageSieve protocol
  #  enableManageSieve = true;

  #  # whether to scan inbound emails for viruses (note that this requires at least
  #  # 1 Gb RAM for the server. Without virus scanning 256 MB RAM should be plenty)
  #  virusScanning = false;
  #};

  #security.acme = {
  #  email = "postmaster@little-fluffy.cloud";
  #  acceptTerms = true;

  #  certs = {
  #    "mail.little-fluffy.cloud".email = "postmaster@little-fluffy.cloud";
  #  };
  #};

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  # Set your time zone.
  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;

  programs = {
  }; # End programs

  security.sudo.wheelNeedsPassword = false;

  users.groups = {
    nix = { };
  };

  users.mutableUsers = false;
  users.users.steve = {
    isNormalUser = true;
    # Enable sudo for the user and create nix group for file permissions
    extraGroups = [ "docker" "nix" "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [ (builtins.readFile ./id_rsa.pub) ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #mtr
    #sqlite3
    bind
    git
    inetutils
    mkpasswd
    openssl
    service-wrapper
    sysstat
    tmux
    vim
    wget
    zsh-powerlevel10k
   ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";
  services.openssh.passwordAuthentication = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "21.11";
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

}

