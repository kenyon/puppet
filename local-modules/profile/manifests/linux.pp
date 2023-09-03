# @summary Linux base configuration
class profile::linux {
  # Linodes normally don't have GRUB installed.
  unless util::is_linode() {
    kernel_parameter { 'quiet':
      ensure   => absent,
      bootmode => default,
    }
  }
}
