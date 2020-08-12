# Configure things specific to Vultr VMs.
# See also: mysite::vms::kvm

class mysite::vms::kvm::vultr {
  # nameserver comes from RA RDNSS on Vultr.
  network::interface { 'ens3':
    family     => 'inet6',
    method     => 'auto',
    dns_search => 'kenyonralph.com',
  }
}
