# Configuration for Private Internet Access VPN
{ ... }:

{ services.openvpn = {
  servers.pia = {
    autoStart = true;
    config = ''
      client
      dev tun
      proto udp
      remote us-newyorkcity.privateinternetaccess.com 1198
      resolv-retry infinite
      nobind
      persist-key
      persist-tun
      cipher aes-128-cbc
      auth sha1
      tls-client
      remote-cert-tls server
      auth-user-pass /home/bhipple/.pia/auth-user-pass
      comp-lzo
      verb 1
      reneg-sec 0
      crl-verify /home/bhipple/.pia/crl.rsa.2048.pem
      ca /home/bhipple/.pia/ca.rsa.2048.crt
      disable-occ
    '';
    };
  };
}
