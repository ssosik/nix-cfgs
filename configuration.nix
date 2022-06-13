# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, inputs, ... }:

{
  imports = [
      (builtins.fetchTarball {
          url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-21.11/nixos-mailserver-nixos-21.11.tar.gz";
          sha256 = "1i56llz037x416bw698v8j6arvv622qc0vsycd20lx3yx8n77n44";
      })
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11";
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  # Nix daemon config
  nix = {
    # Automate garbage collection
    gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 7d";
    };

    # Flakes settings
    package = pkgs.nixFlakes;
    registry.nixpkgs.flake = inputs.nixpkgs;

    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';

    settings = {
      # Automate `nix store --optimise`
      auto-optimise-store = true;
    };
  };

  mailserver = {
    enable = true;
    fqdn = "mail.little-fluffy.cloud";
    domains = [ "little-fluffy.cloud" "scooby.little-fluffy.cloud" "fluffy-little.cloud" ];

    # A list of all login accounts. To create the password hashes, use
    # mkpasswd -m sha-512 "super secret password"
    loginAccounts = {
        "steve@little-fluffy.cloud" = {
            hashedPassword = "$6$JP4YI90.Zley$0UOShElbb8qNndanXmlIiq3ASQhRqzwnpoaMopnZL8LWniYHHnbMbQ4cKCU9b4z3HMmGWke0pw0RiJWvTII.P/";

            aliases = [
                "postmaster@little-fluffy.cloud"
            ];

            # Make this user the catchAll address for domains little-fluffy.cloud
            catchAll = [
              "little-fluffy.cloud"
              "fluffy-little.cloud"
            ];
        };

        "monit@scooby.little-fluffy.cloud" = {
            hashedPassword = "$6$nWSLeS8kRWL$IPpKa9SZlMJ8/Q/hy28BUSIrrODhVSeprc34Mf/Qbr5PrLEB09rRzmBj9hbAlxr6pg.h329nXIHA/HxsuQ7N4.";
        };

        "alerts@scooby.little-fluffy.cloud" = {
            hashedPassword = "$6$VlvVu5JEWEmUEHw$mQtUeYz9FZmO2b1kR9rqe09y/DBwhATM4WdcDKLnn07kQQ5XdozdcQRoGAPoDn4IbBisS5CWLmrw1aa6IUPeh.";
        };
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = 3;

    # Enable IMAP and POP3
    enableImap = true;
    enablePop3 = true;
    enableImapSsl = true;
    enablePop3Ssl = true;

    # Enable the ManageSieve protocol
    enableManageSieve = true;

    # whether to scan inbound emails for viruses (note that this requires at least
    # 1 Gb RAM for the server. Without virus scanning 256 MB RAM should be plenty)
    virusScanning = false;
  };

  security.acme = {
    email = "postmaster@little-fluffy.cloud";
    acceptTerms = true;

    certs = {
      "mail.little-fluffy.cloud".email = "postmaster@little-fluffy.cloud";
    };
  };

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
  # $ nix search nixpkgs wget
  environment.systemPackages = with pkgs; [
    bind
    git
    inetutils
    mkpasswd
    openssl
    service-wrapper
    sqlite
    sysstat
    tmux
    vim
    wget
    zsh-powerlevel10k
   ];

  # Open ports in the firewall.
  networking.firewall = {
    allowedTCPPorts = [ 443 53589 ];
    allowedUDPPorts = [ 443 ];
  };

  # List services that you want to enable:
  services.borgbackup.jobs = {
    mailBackup = {
      paths = [ "/var/vmail" "/var/dkim" ];
      doInit = true;
      repo = "de1576@de1576.rsync.net:mail.little-fluffy.cloud/mail";
      encryption.mode = "none";
      environment.BORG_RSH = "ssh -i /root/.ssh/rsync.net";
      compression = "auto,lzma";
      startAt = "daily";
      extraArgs = "--remote-path=borg1";
    };
    etcNixos = {
      paths = [ "/etc/nixos" ];
      doInit = true;
      repo = "de1576@de1576.rsync.net:mail.little-fluffy.cloud/nixos";
      encryption.mode = "none";
      environment.BORG_RSH = "ssh -i /root/.ssh/rsync.net";
      compression = "auto,lzma";
      startAt = "weekly";
      extraArgs = "--remote-path=borg1";
    };
    taskServer = {
      paths = [ "/var/lib/taskserver" ];
      doInit = true;
      repo = "de1576@de1576.rsync.net:mail.little-fluffy.cloud/taskserver";
      encryption.mode = "none";
      environment.BORG_RSH = "ssh -i /root/.ssh/rsync.net";
      compression = "auto,lzma";
      startAt = "daily";
      extraArgs = "--remote-path=borg1";
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
    ports = [ 64122 ];
    openFirewall = true;
  };

  services.roundcube = {
    enable = false;
    hostName = "mail.little-fluffy.cloud";
    extraConfig = ''
      $config['smtp_server'] = "tls://%n";
    '';
  };

  services.monit = {
    enable = true;
    config = ''
       set daemon 300 with start delay 120
       set mailserver mail.little-fluffy.cloud
       set alert root@little-fluffy.cloud reminder on 120 cycles
       set eventqueue basedir /var/monit slots 5000

       check filesystem mail.little-fluffy.cloud-rootfs with path /dev/vda3
              if space usage > 50% then alert

       check program SystemDegraded with path "/run/current-system/sw/bin/systemctl is-system-running"
         if status != 0 then alert
    '';
  };

  services.fail2ban = {
    enable = true;
    jails = {
      DEFAULT = ''
        bantime  = 3600
        blocktype = DROP
        logpath  = /var/log/auth.log
      '';
      ssh = ''
        enabled = ${lib.boolToString (config.services.openssh.enable)}
        filter = sshd
        maxretry = 4
        action = iptables[name=SSH, port=ssh, protocol=tcp]
      '';
      sshd-ddos = ''
        enabled = ${lib.boolToString (config.services.openssh.enable)}
        filter = sshd-ddos
        maxretry = 4
        action   = iptables[name=ssh, port=ssh, protocol=tcp]
      '';
      dovecot = ''
        enabled = ${lib.boolToString (config.services.postfix.enable)}
        filter   = dovecot
        maxretry = 3
        action   = iptables[name=dovecot, port=smtp, protocol=tcp]
      '';
      monit = ''
        enabled = ${lib.boolToString (config.services.monit.enable)}
        filter   = monit
        maxretry = 3
        action   = iptables[name=monit, port=http, protocol=tcp]
      '';
      roundcube-auth = ''
        enabled = ${lib.boolToString (config.services.roundcube.enable)}
        filter   = roundcube-auth
        maxretry = 3
        action   = iptables[name=roundcube-auth, port=http, protocol=tcp]
      '';
      postfix = ''
        enabled = ${lib.boolToString (config.services.postfix.enable)}
        filter   = postfix
        maxretry = 3
        action   = iptables[name=postfix, port=smtp, protocol=tcp]
      '';
      postfix-sasl = ''
        enabled = ${lib.boolToString (config.services.postfix.enable)}
        filter   = postfix-sasl
        port     = postfix,imap3,imaps,pop3,pop3s
        maxretry = 3
        action   = iptables[name=postfix, port=smtp, protocol=tcp]
      '';
      postfix-ddos = ''
        enabled = ${lib.boolToString (config.services.postfix.enable)}
        filter   = postfix-ddos
        maxretry = 3
        action   = iptables[name=postfix, port=submission, protocol=tcp]
        bantime  = 7200
      '';
      nginx-req-limit = ''
        enabled = ${lib.boolToString (config.services.nginx.enable)}
        filter = nginx-req-limit
        maxretry = 10
        action = iptables-multiport[name=ReqLimit, port="http,https", protocol=tcp]
        findtime = 600
        bantime = 7200
      '';
    };
  };

  services.taskserver = {
    enable = true;
    debug = false;
    ipLog = false;
    fqdn = "mail.little-fluffy.cloud";
    listenHost = "mail.little-fluffy.cloud";
    organisations.Public.users = [ "steve" ];
    config = {
      debug.tls = 3;
    };
    pki.manual = {
      #server.cert = "/var/lib/acme/mail.little-fluffy.cloud/cert.pem";
      #server.key = "/var/lib/acme/mail.little-fluffy.cloud/key.pem";
      server.cert = "/var/lib/taskserver/keys/server.cert";
      server.key = "/var/lib/taskserver/keys/server.key";
      ca.cert = "/var/lib/taskserver/keys/ca.cert.pem";
    };
  };

  environment.etc."fail2ban/filter.d/sshd-ddos.conf" = {
    enable = (config.services.openssh.enable);
    text = ''
      [Definition]
      failregex = {sshd(?:\[\d+\])?: Did not receive identification string from <HOST>$}
      {sshd(?:\[\d+\])?: Connection from <HOST> port \d+ on \S+ port 22 rdomain ""$}
      ignoreregex =
    '';
  };

  environment.etc."fail2ban/filter.d/postfix-sasl.conf" = {
    enable = (config.services.postfix.enable);
    text = ''
      # Fail2Ban filter for postfix authentication failures
      [INCLUDES]
      before = common.conf
      [Definition]
      daemon = postfix/smtpd
      failregex = ^%(__prefix_line)swarning: [-._\w]+\[<HOST>\]: SASL (?:LOGIN|PLAIN|(?:CRAM|DIGEST)-MD5) authentication failed(: [ A-Za-z0-9+/]*={0,2})?\s*$
    '';
  };

  environment.etc."fail2ban/filter.d/postfix-ddos.conf" = {
    enable = (config.services.postfix.enable);
    text = ''
      [Definition]
      failregex = lost connection after EHLO from \S+\[<HOST>\]
    '';
  };

  environment.etc."fail2ban/filter.d/nginx-req-limit.conf" = {
    enable = (config.services.nginx.enable);
    text = ''
      [Definition]
      failregex = limiting requests, excess:.* by zone.*client: <HOST>
    '';
  };
}

