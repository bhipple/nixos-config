{ config, pkgs, ... }:

{
  imports = [ ./credentials.nix ];
  services.ddclient = {
    enable = true;
    domain = "smilodons.org";
    server = "domains.google.com";

    # Set username and password fields in credentials.nix
  };
}
