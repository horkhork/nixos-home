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

      # My custom packages
      <nixpkgs-ssosik/dnscrypt-proxy2-blacklist-updater.nix>

      # Enable home-manager
      (import "${home-manager}/nixos")

    ];

  system.stateVersion = "20.03";
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  networking = {
    # Set hostName in non-git controlled ./hostname.nix

    interfaces = {
      eno1.useDHCP = true;
      enp1s0.useDHCP = true;
      enp2s0.useDHCP = true;
    };

    resolvconf.useLocalResolver = true;

    firewall = {
      allowedTCPPorts = [ 8443 53 ]; # 8443 for Unifi UI
      allowedUDPPorts = [ 53 ]; # For remote DNS clients
    };
  };

  time.timeZone = "America/New_York";

  virtualisation.docker.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bind
    certbot
    git
    inetutils
    mtr
    service-wrapper
    sysstat
    tmux
    vim
    zsh-powerlevel10k
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  nixpkgs.config.allowUnfree = true; # For Unifi

  # Enable DNSCrypt
  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy2";
  };

  services = {
    dnscrypt-proxy2 = {
      enable = true;
      settings = {
        listen_addresses = [ "0.0.0.0:53" ];
        ipv6_servers = true;
        require_dnssec = true;
        log_level = 2;

        query_log.file = "/var/lib/dnscrypt-proxy2/query.log";

        blacklist = {
          blacklist_file = "/var/lib/dnscrypt-proxy2/dnscrypt-proxy-blacklist.txt";
          log_file = "/var/lib/dnscrypt-proxy2/blocked.log";
        };

        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v2/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v2/public-resolvers.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
          refresh_delay = 72;
        };

        # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v2/public-resolvers.md
        server_names = [ "doh-crypto-sx" "doh-crypto-sx-ipv6" "doh-eastus-pi-dns" "doh-eastus-pi-dns-ipv6" "cs-usnc" "cloudflare" ];

      };
    };

    dnscrypt-proxy2-blacklist-updater = {
      enable = true;
      blacklist-sources = [
        "file:domains-blacklist-local-additions.txt"
        "https://osint.bambenekconsulting.com/feeds/c2-dommasterlist.txt"
        "https://hosts-file.net/ad_servers.txt"
        "https://mirror1.malwaredomains.com/files/justdomains"
        "https://www.malwaredomainlist.com/hostslist/hosts.txt"
        "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt"
        "https://easylist-downloads.adblockplus.org/easylist_noelemhide.txt"
        "https://easylist-downloads.adblockplus.org/easylistchina.txt"
        "https://easylist-downloads.adblockplus.org/fanboy-social.txt"
        "https://pgl.yoyo.org/adservers/serverlist.php"
        "https://raw.githubusercontent.com/Dawsey21/Lists/master/adblock-list.txt"
        "https://raw.githubusercontent.com/cjx82630/cjxlist/master/cjxlist.txt"
        "https://raw.githubusercontent.com/liamja/Prebake/master/obtrusive.txt"
        "https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt"
        "https://s3.amazonaws.com/lists.disconnect.me/simple_malware.txt"
        "https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt"
        "http://sysctl.org/cameleon/hosts"
        "https://raw.githubusercontent.com/azet12/KADhosts/master/KADhosts.txt"
        "https://ssl.bblck.me/blacklists/domain-list.txt"
        "https://someonewhocares.org/hosts/hosts"
        "https://raw.githubusercontent.com/notracking/hosts-blocklists/master/dnscrypt-proxy/dnscrypt-proxy.blacklist.txt"
        "https://raw.githubusercontent.com/nextdns/cname-cloaking-blocklist/master/domains"
        "https://reddestdream.github.io/Projects/MinimalHosts/etc/MinimalHostsBlocker/minimalhosts"
        "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt"
        "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
        "https://mirror1.malwaredomains.com/files/justdomains"
        "http://sysctl.org/cameleon/hosts"
        "https://zeustracker.abuse.ch/blocklist.php?download=domainblocklist"
        "https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt"
        "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
        "https://hosts-file.net/ad_servers.txt"
      ];
      whitelisted-domains = [
        #"163.com"
        "a-msedge.net"
        #"amazon.com"
        "app.link"
        #"appsflyer.com"
        "azurewebsites.net"
        "cdn.optimizely.com"
        "cdnetworks.com"
        "cdninstagram.com"
        "cloudapp.net"
        "cdn.cloudflare.net"
        "download.dnscrypt.info"
        "edgekey.net"
        "edgesuite.net"
        "elasticbeanstalk.com"
        "fastly.net"
        "github.com"
        "github.io"
        "googleadservices.com"
        "gvt1.com"
        "gvt2.com"
        "invalid"
        "j.mp"
        "l-msedge.net"
        "lan"
        #"liveinternet.ru"
        "localdomain"
        #"microsoft.com"
        "msedge.net"
        "nsatc.net"
        "ocsp.apple.com"
        "ovh.net"
        "polyfill.io"
        "pusher.com"
        "pusherapp.com"
        "raw.githubusercontent.com"
        "revinate.com"
        #"s.youtube.com"
        "spotify.com"
        "tagcommander.com"
        "windows.net"
      ];
    };

    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
    };

    unifi = {
      enable = true;
      openPorts = true;
      unifiPackage = pkgs.unifiStable;
    };

    monit = {
      enable = true;
      config = ''
         set daemon 300 with start delay 120
         set mailserver smtp.little-fluffy.cloud port 587
           username monit@scooby.little-fluffy.cloud password XXXXX
           using tls
         set alert root@little-fluffy.cloud
         set eventqueue basedir /var/monit slots 5000

         check filesystem rootfs with path /dev/sda1
           if space usage > 30% then alert

         check file dnscrypt-proxy-blacklist.txt with path
           /var/lib/dnscrypt-proxy2/dnscrypt-proxy-blacklist.txt
           if timestamp > 1 hour then alert

         check program SystemDegraded with path "/run/current-system/sw/bin/systemctl is-system-running"
           if status != 0 then alert

         check host stupa-net-dnscrypt with address 127.0.0.1
            if failed port 53 type udp protocol dns with timeout 2 seconds 3 times within 3 cycles then alert

         check process unifi matching "unifi/run"
           if failed host localhost port 8443 protocol HTTPS request "/setup/" then alert
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
