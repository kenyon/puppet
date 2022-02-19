# @summary time synchronization configuration
#
# @param refclocks
#   Chrony reference clock config lines.
#
class profile::timesync (Array[String[1]] $refclocks = []) {
  package { 'ntp':
    ensure => absent,
  }
  -> class { 'chrony':
    servers    => [],
    pools      => ['2.pool.ntp.org'],
    refclocks  => $refclocks,
    queryhosts => [''],
  }

  systemd::dropin_file { 'chrony.conf':
    unit    => 'chrony.service',
    content => @(EOT),
      [Service]
      Restart=on-failure
      | EOT
    notify  => Class['chrony'],
  }
}
