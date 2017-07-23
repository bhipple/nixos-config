{ config, pkgs, ... }:

{
  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Enable Docker Daemon
  virtualisation.docker.enable = true;

  time.timeZone = "America/New_York";

  # System profile packages
  environment.systemPackages = with pkgs; [
    dmenu
    gitAndTools.gitFull
    mailutils
    wget
    xlibs.xmessage

    (haskellPackages.ghcWithPackages (ps: with ps;
      [ xmonad
        xmobar
        xmonad-contrib
        xmonad-extras ]))
  ];

  environment.variables = { IPFS_PATH = "/var/lib/ipfs/.ipfs"; };

  networking.networkmanager.enable = true;

  hardware = {
    opengl.enable = true;
    opengl.driSupport = true;
    opengl.driSupport32Bit = true;
    pulseaudio = {
      enable = true;
      support32Bit = true;
      systemWide = false;
    };
  };

  services = {
    cron = {
      enable = true;
      systemCronJobs = [
        "* * * * *  bhipple  /home/bhipple/bin/sync-repos > /tmp/bhipple-sync-repos 2&>1"
      ];
    };

    postfix.enable = true;
    ipfs.enable = true;

    xserver = {
      enable = true;
      layout = "us";

      # Override the caps-lock key with the compose key
      # See /etc/X11/xkb/rules/evdev.lst for more options
      xkbOptions = "caps:ctrl_modifier";

      # Enable XMonad Configuration extras
      windowManager = {
        default = "xmonad";
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = haskellPackages: [
            haskellPackages.xmobar
            haskellPackages.xmonad-contrib
            haskellPackages.xmonad-extras
          ];
        };
      };

      desktopManager = {
        plasma5.enable = false;
        xterm.enable = true;
        xfce.enable = true;

        # Just use xmonad
        default = "none";
      };
    };

    openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
      forwardX11 = false;
    };

  };

  programs = {
    zsh.enable = true;
  };

  users.defaultUserShell = "/run/current-system/sw/bin/zsh";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.bhipple = {
    isNormalUser = true;
    description = "Benjamin Hipple";
    extraGroups = [ "adbusers" "bhipple" "docker" "ipfs" "networkmanager" "users" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCuP/Z+l3KI5g0SmZ4s0vv3N2OdUEAwc9sBuFG1d8XYLbJEaaTONBGh2sSzMjqNnetyl1e9lz/Yn/406gksjhweR6A1AqTd/Ty8CKzzOD7YCu0QBMOo+hgHxO3LQS+WbB3ygAjZ/uzakSDwaAxHQcZgRiRNFIf+zadQgJ+4sVB2NDTGL16L1Ok252NpBfGdnojU51E2ZnQLj6Dq5ZgrpLrfZEAJkPqcmcjl2IhoFDveSxTvvmoxBAIbZYgHdQY/hSz7k3UOBIBNNV2u6XxW1pr35ySwJVGFav+6KiZR1IaHAka9GW8EeX0Au9QEmUVIZcdWrJHOB4xO4sgSCKaiI7bB"
    ];
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";
}
