# -*- coding: utf-8 -*-
# Configure things specific to a machine running a KVM hypervisor.

class mysite::roles::hypervisor_kvm {
  if $facts['os']['name'] == 'Debian' {
    file_capability { '/usr/lib/qemu/qemu-bridge-helper':
      capability => 'cap_net_admin+ep',
    }

    stdlib::ensure_packages(
      ['libosinfo-bin', 'virtinst'],
      {ensure => installed},
    )
  } else {
    err('OS not supported yet')
  }
}
