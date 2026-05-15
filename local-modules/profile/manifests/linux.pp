# @summary Linux base configuration
class profile::linux {
  kernel_parameter { 'quiet':
    ensure   => absent,
    bootmode => default,
  }

  kernel_parameter { 'fsck.repair':
    ensure => present,
    value  => 'yes',
  }
}
