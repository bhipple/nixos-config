# Base defaults for my personal machines
{ pkgs, ... }:
{
  # System profile packages
  environment.systemPackages = with pkgs; [
    brave
    chromium
    dmenu
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

  hardware.graphics.enable = true;

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

    grafana = {
      enable = true;
      settings = {};
      provision = {
        enable = true;
        #datasources = [
        #  {
        #    name = "brh-finance";
        #    type = "influxdb";
        #    access = "direct";
        #    url = http://localhost:8086;
        #    database = "brh-finance";
        #  }
        #];
        dashboards.path = ./grafana/provisioning/dashboards;
      };

      # Not available until 24.11
      # declarativePlugins = [ pkgs.grafanaPlugins.yesoreyeram-infinity-datasource ];
    };

    # Replace this with csv; it's too complicated
    influxdb.enable = true;

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
    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
      extraUpFlags = ["--advertise-exit-node"];
    };
  };

  users.extraGroups = {
    plugdev = { gid = 500; };
  };

  virtualisation.docker.enable = true;

}
