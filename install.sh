#!/bin/sh

set -euxo pipefail

# Complete the install; set the channels, rebuild the system, install my custom
# configuration.nix

# Update the system
nixos-rebuild switch --upgrade

nix-channel --add https://nixos.org/channels/nixos-20.03 nixos
nix-channel --add https://horkhork.github.io/nixpkgs-ssosik/
nix-channel --update

cd /etc
mv nixos nixos.install

git clone https://github.com/horkhork/nixos-home.git nixos
cp nixos.install/hardware-configuration.nix nixos/.
cd nixos

cp hostname.nix.tmpl hostname.nix
sed -i 's/CHANGEME/'$1'/g' hostname.nix

# A little unclear on why this doesn't yet, create it manually instead
mkdir -m 0755 -p /nix/var/nix/{profiles,gcroots}/per-user/steve

nixos-rebuild switch --upgrade

sudo chgrp -R nix /etc/nixos
sudo chmod -R ug+rw /etc/nixos

