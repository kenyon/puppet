# My standard NTP (ntpd) configuration.

# For non-Linode KVM VM nodes, exclude this class (- --mysite::ntp)
# and instead include mysite::vms::kvm.

class mysite::ntp (Array[String] $servers = []) {
  class { '::ntp':
    iburst_enable   => true,
    servers         => $servers,
    pool            => [
      '2.pool.ntp.org',
    ],
    restrict        => [
      'localhost',
      'default limited noquery',
    ],
    disable_monitor => false,
    driftfile       => '/var/lib/ntp/ntp.drift',
    leapfile        => '/usr/share/zoneinfo/leap-seconds.list',
  }
}
