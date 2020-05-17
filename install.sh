#!/bin/sh

set -euxo pipefail

# Complete the install; add updated channels and rebuild the system with the
# full-configuration.nix

nix-channel --add https://nixos.org/channels/nixos-20.03 nixos
nix-channel --add https://horkhork.github.io/nixpkgs-ssosik/
nix-channel --update

cp /etc/nixos/full-configuration.nix /etc/nixos/configuration.nix

nixos-rebuild switch --upgrade
