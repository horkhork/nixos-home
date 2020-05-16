#!/bin/sh
#
# Complete install

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

nixos-rebuild switch --upgrade

sudo chgrp -R nix /etc/nixos
sudo chmod -R ug+rw /etc/nixos

