{ pkgs, ... }:
{
  hardware.ledger.enable = true; # Ledger Nano S

  hardware.keyboard.qmk.enable = true;
  hardware.keyboard.zsa.enable = true; # Ergo-Dox, Voyager

  services.udev.extraRules =
    # Talon
    ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2104", ATTRS{idProduct}=="0127", GROUP="plugdev", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2104", ATTRS{idProduct}=="0118", GROUP="plugdev", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2104", ATTRS{idProduct}=="0106", GROUP="plugdev", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2104", ATTRS{idProduct}=="0128", GROUP="plugdev", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2104", ATTRS{idProduct}=="010a", GROUP="plugdev", TAG+="uaccess"
    '';
}
