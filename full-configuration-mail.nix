# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "98fa8f63b8d7508e84275eb47cd7f3003e6b9510";
    ref = "release-20.03";
  };
in

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ./hostname.nix

      # Enable home-manager
      (import "${home-manager}/nixos")

      (builtins.fetchTarball {
          url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/v2.3.0/nixos-mailserver-v2.3.0.tar.gz";
          sha256 = "0lpz08qviccvpfws2nm83n7m2r8add2wvfg9bljx9yxx8107r919";
      })

    ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
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
    };

    # Extra virtual aliases. These are email addresses that are forwarded to
    # loginAccounts addresses.
    extraVirtualAliases = {
        # address = forward address;
        "abuse@little-fluffy.cloud" = "steve@little-fluffy.cloud";
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
  };

  system.stateVersion = "20.03";
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  networking = {
    # Set hostName in non-git controlled ./hostname.nix

    interfaces = {
      eno1.useDHCP = true;
      enp1s0.useDHCP = true;
      enp2s0.useDHCP = true;
    };

    resolvconf.useLocalResolver = true;

    firewall = {
      allowedTCPPorts = [ 443 ]; # 8443 for Unifi UI
      allowedUDPPorts = [ 443 ]; # For remote DNS clients
    };
  };

  time.timeZone = "America/New_York";

  #virtualisation.docker.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bind
    git
    inetutils
    mkpasswd
    #mtr
    service-wrapper
    sysstat
    tmux
    vim
    zsh-powerlevel10k
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  #programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  services = {

    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
    };

    roundcube = {
      enable = true;
      hostName = "mail.little-fluffy.cloud";
      extraConfig = ''
        $config['smtp_server'] = "tls://%n";
      '';
    };

    monit = {
      enable = true;
      config = ''
         set daemon 300 with start delay 120
         set mailserver mail.little-fluffy.cloud
         set alert root@little-fluffy.cloud
         set eventqueue basedir /var/monit slots 5000

         check filesystem rootfs with path /dev/vda3
                if space usage > 30% then alert

         check program SystemDegraded with path "/run/current-system/sw/bin/systemctl is-system-running"
           if status != 0 then alert
      '';
    };

  }; # End services

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    ohMyZsh.enable = true;
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  };

  programs.vim.defaultEditor = true;

  security.sudo.wheelNeedsPassword = false;

  users.groups = {
    nix = { };
  };

  users.users.steve = {
    isNormalUser = true;
    extraGroups = [ "docker" "nix" "wheel" ]; # Enable ‘sudo’ for the user and create nix group for file permissions
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8E/PbfpTIDPLYl6+KbfauImwcDRQp4t7azgOjzRckwKHZ0AzfJUKVs7lqTaUFbim0IK83fC9AFAW0Y/sUf5SOu2As5UNxLW4/9ol8tXECOkrgZQK7dVLuCEiVFX2/nf4Rds0XBC1DdpPwJAy909/eXnjUKCR/1QKya3KsNQn9ZPvypZ/mdhxpJZ36DCasExU56tVF3xFfyFX+rIukWRKVOWjB6crEyDR8rv1MR22IhpRhZmq35sjDIn03ZYJ4KzDT6dLPrNolKh+Ys8uhcJKDHEIop3Id6WMU43kZgNiHmGN/0j4Xy1FpYro0EmuFcs4bf1/9k1/4ALAem+yhrr75 linode nix test" ];
  };

  home-manager.users.steve = import "/etc/nixos/${config.networking.hostName}.nix" pkgs;
}
