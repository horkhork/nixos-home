# Base configuration.nix file to be used after bootstrapping an instance from a
# snapshot

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./hostname.nix
    ];

  networking = {
    # Set hostName in non-git controlled ./hostname.nix
  };

  time.timeZone = "America/New_York";

  environment.systemPackages = with pkgs; [
    git
    inetutils
    mtr
    sysstat
    tmux
    vim
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  services = {
    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
    };
  }; # End services

  programs.vim.defaultEditor = true;

  security.sudo.wheelNeedsPassword = false;

  users.groups = {
    nix = { };
  };

  users.users.steve = {
    isNormalUser = true;
    extraGroups = [ "nix" "wheel" ]; # Enable ‘sudo’ for the user and create nix group for file permissions
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8E/PbfpTIDPLYl6+KbfauImwcDRQp4t7azgOjzRckwKHZ0AzfJUKVs7lqTaUFbim0IK83fC9AFAW0Y/sUf5SOu2As5UNxLW4/9ol8tXECOkrgZQK7dVLuCEiVFX2/nf4Rds0XBC1DdpPwJAy909/eXnjUKCR/1QKya3KsNQn9ZPvypZ/mdhxpJZ36DCasExU56tVF3xFfyFX+rIukWRKVOWjB6crEyDR8rv1MR22IhpRhZmq35sjDIn03ZYJ4KzDT6dLPrNolKh+Ys8uhcJKDHEIop3Id6WMU43kZgNiHmGN/0j4Xy1FpYro0EmuFcs4bf1/9k1/4ALAem+yhrr75 linode nix test" ];
  };

}

