# @summary configure things specific to Vultr VMs
#   See also: profile::vms::kvm
#
class profile::vms::kvm::vultr {
  # nameserver comes from RA RDNSS on Vultr.
  network::interface { 'ens3':
    family     => 'inet6',
    method     => 'auto',
    dns_search => 'kenyonralph.com',
  }
}
