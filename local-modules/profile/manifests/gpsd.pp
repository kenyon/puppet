# @summary Manage gpsd
#
# @param devices
#   Devices gpsd should collect.
class profile::gpsd (
  Array[String[1]] $devices = [],
) {
  [
    'gpsd-clients',
    'gpsd',
    'pps-tools',
  ].each |String[1] $pkg| {
    package { $pkg:
      ensure => installed,
    }
  }

  systemd::dropin_file { 'gpsd.conf':
    unit    => 'gpsd.service',
    content => @(EOT),
      # Managed by Puppet.
      [Unit]
      # gpsd needs to be restarted if chrony is restarted.
      PartOf=chrony.service
      | EOT
    require => Package['gpsd'],
  }
  -> service { 'gpsd':
    ensure => running,
    enable => true,
  }

  file { '/etc/default/gpsd':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Service['gpsd'],
    require => Package['gpsd'],
    content => @("EOT"),
      # Managed by Puppet.

      # Devices gpsd should collect to at boot time.
      # They need to be read/writeable, either by user gpsd or the group dialout.
      DEVICES="${devices.join(' ')}"

      # Other options you want to pass to gpsd
      GPSD_OPTIONS="--nowait"

      # Automatically hot add/remove USB GPS devices via gpsdctl
      USBAUTO="true"
      | EOT
  }

  munin::plugin { 'gpsd':
    ensure         => present,
    source         => 'https://raw.githubusercontent.com/kenyon/munin-monitoring-contrib/c31973d3c8a0e7c78f90d3b1dd8aa3854180f7f8/plugins/gpsd/gpsd',
    checksum       => 'sha256',
    checksum_value => '3fc236dac1d1d53f0ec7058459dd6c526385927099d46a1ac0389825ed91cace',
  }
}
