# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  #home-manager = builtins.fetchTarball {
  #    url = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  #    sha256 = "1557573w1g0an7ks8khqd3jvbwq9lcdbf4l3yj19pmqzq1gvsn9f";
  #};

in

{
  imports =
    [ # Include the results of the hardware scan.
      #./hardware-configuration.nix

      # Enable home-manager
      #(import "${home-manager}/nixos")

      #(builtins.fetchTarball {
      #    url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-21.11/nixos-mailserver-nixos-21.11.tar.gz";
      #    sha256 = "0000000000000000000000000000000000000000000000000000";
      #})
    ];

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

  # networking.hostName = "mail"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;

  programs = {
    #fzf = {
    #  enable = true;
    #  enableZshIntegration = true;
    #};

    #git = {
    #  enable = true;
    #  userName = "Steve Sosik";
    #  userEmail = "steve@little-fluffy.cloud";
    #  aliases = {
    #    lg = "log --graph --oneline --decorate --all";
    #    com = "commit -v";
    #    fet = "fetch -v";
    #    co = "!git checkout $(git branch | fzf-tmux -r 50)";
    #    a = "add -p";
    #    pu = "pull --rebase=true origin master";
    #    ignore = "update-index --skip-worktree";
    #    unignore = "update-index --no-skip-worktree";
    #    hide = "update-index --assume-unchanged";
    #    unhide = "update-index --no-assume-unchanged";
    #    showremote = "!git for-each-ref --format=\"%(upstream:short)\" \"$(git symbolic-ref -q HEAD)\"";
    #    prune-merged = "!git branch -d $(git branch --merged | grep -v '* master')";
    #  };
    #  extraConfig = {
    #    core = {
    #      editor = "vim";
    #      fileMode = "false";
    #      filemode = "false";
    #    };
    #    push = {
    #      default = "simple";
    #    };
    #    merge = {
    #      tool = "vimdiff";
    #      conflictstyle = "diff3";
    #    };
    #    pager = {
    #      branch = "false";
    #    };
    #    credential = {
    #      helper = "cache --timeout=43200";
    #    };
    #  };
    #};

    #gpg.enable = true;
    # Let Home Manager install and manage itself.
    #home-manager.enable = true;
    #jq.enable = true;
    #lesspipe.enable = true;
    #readline.enable = true;

    #vim = {
    #  defaultEditor = true;

    #  enable = true;
    #  extraConfig = builtins.readFile "./dot.vimrc";
    #  #settings = {
    #  #   relativenumber = true;
    #  #   number = true;
    #  #};
    #  #plugins = [
    #  #  pkgs.vimPlugins.Jenkinsfile-vim-syntax
    #  #  pkgs.vimPlugins.ale
    #  #  pkgs.vimPlugins.ansible-vim
    #  #  pkgs.vimPlugins.calendar-vim
    #  #  #pkgs.vimPlugins.direnv-vim
    #  #  pkgs.vimPlugins.emmet-vim
    #  #  pkgs.vimPlugins.fzf-vim
    #  #  pkgs.vimPlugins.goyo-vim
    #  #  pkgs.vimPlugins.jedi-vim
    #  #  pkgs.vimPlugins.jq-vim
    #  #  pkgs.vimPlugins.molokai
    #  #  pkgs.vimPlugins.nerdcommenter
    #  #  pkgs.vimPlugins.nerdtree
    #  #  pkgs.vimPlugins.nerdtree-git-plugin
    #  #  pkgs.vimPlugins.rust-vim
    #  #  pkgs.vimPlugins.tabular
    #  #  pkgs.vimPlugins.vim-airline
    #  #  pkgs.vimPlugins.vim-airline-themes
    #  #  pkgs.vimPlugins.vim-devicons
    #  #  pkgs.vimPlugins.vim-eunuch
    #  #  pkgs.vimPlugins.vim-fugitive
    #  #  pkgs.vimPlugins.vim-gitgutter
    #  #  #pkgs.vimPlugins.vim-go
    #  #  pkgs.vimPlugins.vim-markdown
    #  #  pkgs.vimPlugins.vim-multiple-cursors
    #  #  pkgs.vimPlugins.vim-nix
    #  #  pkgs.vimPlugins.vim-plug
    #  #  pkgs.vimPlugins.vim-repeat
    #  #  pkgs.vimPlugins.vim-sensible
    #  #  pkgs.vimPlugins.vim-speeddating
    #  #  pkgs.vimPlugins.vim-surround
    #  #  pkgs.vimPlugins.vim-terraform
    #  #  pkgs.vimPlugins.vim-unimpaired
    #  #];
    #};

    #zsh = {
    # # programs.zsh = {
    # #   enable = true;
    # #   autosuggestions.enable = true;
    # #   ohMyZsh.enable = true;
    # #   promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    # # };

    #  enable = true;
    #  enableAutosuggestions = true;
    #  enableCompletion = true;
    #  ohMyZsh.enable = true;
    #  autocd = true;
    #  history = {
    #    extended = true;
    #    save = 50000;
    #    share = true;
    #    size = 50000;
    #  };
    #};

  }; # End programs

  #home.file.".p10k.zsh".text = builtins.readFile "./dot.p10k.zsh";
  #home.file.".zshrc".source = "./dot.zshrc";

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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

}

