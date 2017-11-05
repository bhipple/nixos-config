# Adds Steven Black's hosts file to NixOS
{ config, pkgs, ... }:

let
  blocked = builtins.readFile (pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/StevenBlack/hosts/76dee94b624dd53013a50684aba9ee61b031bfd7/hosts";
    sha256 = "163lms67j0k9yqp1xhdfq04w168z4j422zj7f7wxl5h2q28srfx5";
  });
in
{
  networking.extraHosts = blocked;
}
