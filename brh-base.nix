# Base defaults for my personal machines
{ pkgs, ... }:
{
  # System profile packages
  environment.systemPackages = with pkgs; [
    brave
    chromium
    dmenu
    git
    gitAndTools.gitFull
    gnupg
    pass
    pinentry-curses
    python3
    slock
    tmux
    vim
    wget
    xautolock
    xorg.xmessage
  ];

  hardware = {
    opengl.enable = true;
    opengl.driSupport = true;
    opengl.driSupport32Bit = true;
    pulseaudio = {
      enable = true;
    };
  };

  location = {
    latitude = 40.71427;
    longitude = -74.00597;
  };

  networking.firewall =
    let
      ssh = [ 22 ];
      wg = [ 51820 ];
    in
    {
      enable = true;
      allowedTCPPorts = ssh ++ wg;
      allowedUDPPorts = wg;
    };

  networking.networkmanager.enable = true;
  networking.wireless.enable = false;

  nix = {
    settings = {
      auto-optimise-store = true;
      trusted-users = [ "bhipple" ];
    };
  };

  programs.adb.enable = false;
  programs.browserpass.enable = true;
  programs.dconf.enable = true;
  programs.gnupg.agent = {
    enable = true;
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
        workstation = true;
      };
    };
    blueman.enable = true;
    fwupd.enable = true;
    gnome.gnome-keyring.enable = true;
    nginx = {
      enable = true;
      config = ''
        events { }
        http {
          server {
            listen 80;
            root /home/bhipple/public_html;
            location / {
              index index.html;
              autoindex on;

              sendfile on;
              tcp_nopush on;
              tcp_nodelay on;
              keepalive_timeout 65;
            }
          }
        }
      '';
    };
    syncthing = {
      enable = true;
      user = "bhipple";
      group = "users";
      dataDir = "/home/bhipple/syncthing";
      openDefaultPorts = true;
    };
    tailscale.enable = true;
  };

  users.extraGroups = {
    plugdev = { gid = 500; };
  };

  virtualisation.docker.enable = false;

}
