# @summary Smokeping configuration
class profile::smokeping {
  # Needed because the QC VPN target, probed by curl, doesn't support secure
  # renegotiation. Unsafe renegotiation is disabled by default in OpenSSL 3.
  # https://stackoverflow.com/a/72245418/124703
  file { '/etc/smokeping/openssl.cnf':
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => @(EOT),
      openssl_conf = openssl_init

      [openssl_init]
      ssl_conf = ssl_sect

      [ssl_sect]
      system_default = system_default_sect

      [system_default_sect]
      Options = UnsafeLegacyRenegotiation
      | EOT
  }
  -> systemd::dropin_file { 'environment.conf':
    unit    => 'smokeping.service',
    content => @(EOT),
      [Service]
      Environment=OPENSSL_CONF=/etc/smokeping/openssl.cnf
      Restart=on-failure
      | EOT
  }
}
