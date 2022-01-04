# nixos configuration files

NixOS configuration files for my various machines.

To install, symlink the appropriate `<hostname>/configuration.nix` to
`/etc/nixos/configuration.nix`

Several files are encrypted with git-crypt; if they're included in the server
setup, run `git crypt unlock` first.

## Install

Run ./install.sh
