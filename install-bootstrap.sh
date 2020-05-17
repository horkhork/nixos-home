#!/bin/sh

set -euxo pipefail

# System initialization for a blank snapshot. Pull down my configs and install
# the bootstrap-configuration

cd /etc
mv nixos nixos.install

#git clone https://github.com/horkhork/nixos-home.git nixos
git clone git@github.com:horkhork/nixos-home.git nixos
cp nixos.install/hardware-configuration.nix nixos/.
cd nixos

cp hostname.nix.tmpl hostname.nix
sed -i 's/CHANGEME/'$1'/g' hostname.nix

ln -s bootstrap-configuration.nix configuration.nix

nixos-rebuild switch --upgrade

chgrp -R nix /etc/nixos
chmod -R ug+rw /etc/nixos
