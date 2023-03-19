{ pkgs, ... }:

{
  services.cron.enable = true;
  services.cron.systemCronJobs = [];
}
