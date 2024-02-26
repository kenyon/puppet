# @summary Linux base configuration
class profile::linux {
  kernel_parameter { 'quiet':
    ensure   => absent,
    bootmode => default,
  }
}
