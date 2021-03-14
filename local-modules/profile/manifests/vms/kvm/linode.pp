# @summary configure things specific to Linodes
#   See also: profile::vms::kvm
#
class profile::vms::kvm::linode {
  # darwin has its own special configuration
  unless $trusted['hostname'] == 'darwin' {
    ensure_packages(
      ['isc-dhcp-client'],
      {ensure => installed},
    )

    network::interface { 'eth0':
      family          => 'inet6',
      method          => 'auto',
      dns_nameservers => '2600:3c01::5 2600:3c01::6 2600:3c01::7',
      dns_search      => 'kenyonralph.com',
    }

    network::interface { 'eth0_legacy':
      interface => 'eth0',
      family    => 'inet',
      method    => 'dhcp',
    }
  }
}
