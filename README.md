# nixos configuration files
NixOS configuration files for my various machines.

To install, symlink the appropriate `<hostname>/configuration.nix` to
`/etc/nixos/configuration.nix`

The `vpn.nix` file is encrypted with git-crypt; if it's included in the server
setup, run `git crypt unlock` first.
