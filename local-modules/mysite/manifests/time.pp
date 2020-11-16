# My time synchronization configuration.

class mysite::time ($refclocks = []) {
  package { 'ntp':
    ensure => absent,
  } -> class { 'chrony':
    servers    => [],
    pools      => ['2.pool.ntp.org'],
    refclocks  => $refclocks,
    queryhosts => [''],
  }
}
