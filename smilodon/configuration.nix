# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../base.nix

      # VPN
      #./private-internet-access.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdd";
  boot.loader.grub.efiSupport = false;

  networking.hostName = "smilodon";

  users.extraUsers.smilodon = {
    isNormalUser = true;
    description = "Smilodon";
    extraGroups = [ "smilodon" "users" "ipfs" "networkmanager" ];
  };

  users.extraUsers.chipple = {
    isNormalUser = true;
    description = "Chris Hipple";
    extraGroups = [ "chipple" "users" "smilodon" "ipfs" "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "AAAAB3NzaC1yc2EAAAADAQABAAABAQC1MQEzpAYvopxVvjsK/3ycEXpSmtqE5oa1Px+TcR5XoZ2H++q4X9CoA0yAa/H3eCVTDd3Kz62iibDHe7+T6YvAgpk6r5tiUGkoFu0TKnukwgsBI5nGgMzUKFo/yWRuNrqDAm+OGzjBhOhD3754i4TQijF23BScHX/DgjLCIn3iil0DsoAj5h0tLpPUSlWXBoJsWmh7r6UN9w8oOvUZQAYpsS0Ch1EFMxItmqnZO5PVpH/giwXxrq2Smx4GSCxV/RdsORGbjWv97vxsf7SoXAivtRYBIg2e4GK0zpPpQOdJFXc9xVsEMpXhk+XsaXfG0Jqo4tdxMhBJA6Sjq02iAc2F"
    ];
  };
}