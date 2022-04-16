{ pkgs, ... }:
{
  security.sudo.extraConfig = ''
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/nix-channel --update
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/nix-store --optimize
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/nixos-rebuild

    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/bluetoothctl
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/poweroff
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/reboot

    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl restart display-manager

    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl restart openvpn-protonvpn
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl start openvpn-protonvpn
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl status openvpn-protonvpn
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl stop openvpn-protonvpn

    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/slock
  '';
}
