#!/bin/sh

set -euxo pipefail

# Complete the install; add updated channels and rebuild the system with the
# full-configuration.nix

nix-channel --add https://nixos.org/channels/nixos-20.03 nixos
nix-channel --add https://horkhork.github.io/nixpkgs-ssosik/
nix-channel --update

unlink /etc/nixos/configuration.nix
ln -s /etc/nixos/full-configuration-mail.nix /etc/nixos/configuration.nix
sudo chgrp -h nix /etc/nixos/configuration.nix
sudo chmod 664 /etc/nixos/configuration.nix
mkdir -m 0755 -p /nix/var/nix/{profiles,gcroots}/per-user/steve

nixos-rebuild switch --upgrade

sudo systemctl restart dnscrypt-proxy2-blacklist-updater.service
