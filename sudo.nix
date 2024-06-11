{ pkgs, lib, ... }:

let
  services = [
    "bluetooth.service"
    "display-manager.service"
    "tailscale.service"
    "wg-quick-protonvpn.service"
  ];

  systemctl = lib.concatMapStrings (s: ''
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl restart ${s}
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl start ${s}
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl status ${s}
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl stop ${s}
  '') services;

  journalctl = lib.concatMapStrings (s: ''
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/journalctl -u ${s}
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/journalctl -u ${s} *
  '') services;
in
{
  security.sudo.extraConfig = ''
    # Nix
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/nix-channel --update
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/nix-store --optimize
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/nixos-rebuild

    # Misc cmds
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/bluetoothctl
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/poweroff
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/reboot
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/slock

    # systemd
    ${systemctl}
    ${journalctl}
  '';
}
