# @summary configure things specific to Linodes
#   See also: profile::vms::kvm
#
# @param longview_api_key
#   Longview API key.
#
class profile::vms::kvm::linode (
  String[1] $longview_api_key,
) {
  apt::source { 'linode-longview':
    location => 'https://apt-longview.linode.com/',
    release  => $facts['os']['distro']['codename'],
    repos    => 'main',
    key      => {
      id     => 'D12F8D2C47B4A16917C9A040BED67E64325A043E',
      source => 'https://apt-longview.linode.com/linode.gpg',
    },
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
      ${longview_api_key}
      | EOT
  }
  -> service { 'longview':
    ensure => running,
    enable => true,
  }
}
