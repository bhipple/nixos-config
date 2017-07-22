{ config, pkgs, ... }:

{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;

    virtualHosts = {
      "smilodons.org" = {
        default = true;
        serverAliases = [ "www.smilodons.org" "localhost" ];

        locations = {
          "/" = {
            root = "/data/www";
            index = "index.html";
          };
        };

        # TODO
        enableSSL = false;
        forceSSL = false;
      };

    };
  };
}
