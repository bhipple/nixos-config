# usbmuxd multiplexes connections to iOS devices over USB. Despite the generic
# name it is Apple-specific: an iPhone exposes only a PTP/imaging interface by
# default, and usbmuxd is what switches it into the USB configuration carrying
# the ipheth interface. It is therefore required for iPhone USB tethering, as
# well as for ifuse and the rest of libimobiledevice.
#
# Upstream has a deadlock. The preflight worker that performs the lockdownd
# handshake on device-add wedges the daemon's client-facing thread when it
# fails with LOCKDOWN_E_MUX_ERROR (-8), which is what happens when its libusb
# handles have gone stale across a suspend/resume. The process stays alive --
# the libusb thread keeps servicing hotplug events -- so systemd never notices
# anything wrong, while the socket silently stops answering and clients get
# "Unable to retrieve device list!". It then ignores SIGTERM until
# TimeoutStopSec expires.
#
# Observed on brh-x21g10 over 60 days: 6 preflight errors, 3 SIGKILL-after-
# timeout hangs, every hang preceded by a preflight error, and the errors
# landing 70-85s after a "Finished System Suspend".
#
# The stock nixpkgs module sets no Restart=, so once wedged it stays wedged
# until someone restarts it by hand.
{ config, pkgs, ... }:
{
  services.usbmuxd.enable = true;

  systemd.services.usbmuxd.serviceConfig = {
    Restart = "always";
    RestartSec = 2;
    # A wedged usbmuxd ignores SIGTERM; don't wait the default 90s for SIGKILL.
    TimeoutStopSec = 5;
  };

  # The hang is resume-triggered, so restart pre-emptively on every resume.
  # --no-block so we never stall the resume transition itself.
  powerManagement.resumeCommands = ''
    ${config.systemd.package}/bin/systemctl --no-block try-restart usbmuxd.service
  '';

  # Restart= only fires when the process dies, and a deadlocked usbmuxd stays
  # alive. So probe the socket and restart on the observed wedge signature.
  # Note "No device found." is the healthy empty-list answer and must not fire.
  systemd.services.usbmuxd-healthcheck = {
    description = "Restart usbmuxd if its socket has stopped answering";
    path = [ pkgs.libimobiledevice config.systemd.package ];
    serviceConfig.Type = "oneshot";
    script = ''
      rc=0
      out=$(timeout 5 idevice_id -l 2>&1) || rc=$?
      if [ $rc -eq 124 ] || echo "$out" | grep -q "Unable to retrieve device list"; then
        echo "usbmuxd socket unresponsive (rc=$rc): $out -- restarting"
        systemctl restart usbmuxd.service
      fi
    '';
  };

  systemd.timers.usbmuxd-healthcheck = {
    description = "Periodic usbmuxd liveness probe";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "2min";
    };
  };
}
