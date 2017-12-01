{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../base.nix
      ../brh-base.nix
      ../hosts.nix
      ../xserver.nix
      ../private-internet-access.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdd";
  boot.loader.grub.efiSupport = false;

  networking.hostName = "brh.desktop";

  environment.systemPackages = with pkgs; [
    amdappsdkFull
  ];

  services = {
    xserver = {
      enable = true;

      # See config in /etc/X11/xorg.conf
      exportConfiguration = true;

      # Use proprietary AMD drivers
      videoDrivers = [ "amdgpu" ];

      xrandrHeads = [
        {
          # Left Monitor
          output = "DVI-D-0";
          monitorConfig = ''
            Option "Rotate" "left"
          '';
        }
        {
          # Center Monitor
          output = "DisplayPort-0";
          primary = true;
          monitorConfig = ''
            Option "Rotate" "left"
          '';
        }
        {
          # Right Monitor
          output = "DVI-D-1";
          monitorConfig = ''
            Option "Rotate" "left"
          '';
        }
      ];
    };
  };
}
