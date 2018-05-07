# Adds Steven Black's aggregated hosts file to NixOS
# https://github.com/StevenBlack/hosts
{ config, pkgs, ... }:
let
  # Block the whole basket of deplorables
  ads_malware_porn_social_media = builtins.readFile (pkgs.fetchurl {
    url = https://raw.githubusercontent.com/StevenBlack/hosts/bd870230f1eb83447381cb489cba3c6be3a2ace7/alternates/porn-social/hosts;
    sha256 = "1cgvxn8xlrlxf2668rlm3250q8wafagkyvqrsn74jiiil03cm54n";
  });
in
{
  networking.extraHosts = ads_malware_porn_social_media;
}
