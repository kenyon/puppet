# @summary configure things specific to Linodes
#   See also: profile::vms::kvm
#
# @param longview_api_key
#   Longview API key.
#
class profile::vms::kvm::linode (
  Sensitive[String[1]] $longview_api_key,
) {
  kernel_parameter { 'console':
    ensure => present,
    value  => 'ttyS0,19200n8',
  }

  grub_config { 'GRUB_GFXPAYLOAD_LINUX':
    value => 'text',
  }

  grub_config { 'GRUB_SERIAL_COMMAND':
    value => 'serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1',
  }

  grub_config { 'GRUB_TERMINAL':
    value => 'serial',
  }

  apt::source { 'linode-longview':
    location     => 'https://apt-longview.linode.com/',
    release      => $facts['os']['distro']['codename'],
    repos        => 'main',
    key          => {
      name   => 'linode.gpg',
      source => 'https://apt-longview.linode.com/linode.gpg',
    },
    architecture => $facts['os']['architecture'],
  }
  -> package { 'linode-longview':
    ensure => installed,
  }
  -> file { '/etc/linode':
    ensure => directory,
  }
  -> file { '/etc/linode/longview.key':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0400',
    content => @("EOT"),
      ${longview_api_key.unwrap}
      | EOT
  }
  ~> service { 'longview':
    ensure => running,
    enable => true,
  }
}
