{ config, pkgs, ... }:

{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "smilodons.org" = {
        default = true;
        locations = {
          "/" = {
            root = "/data/www";
            index = "index.html";
            extraConfig = "autoindex on;";
          };
        };

        enableACME = true;
        enableSSL = true;
        forceSSL = true;
      };

    };
  };
}
