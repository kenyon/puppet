# @summary Configure things specific to a machine running a KVM hypervisor
class profile::hypervisor_kvm {
  [
    'libosinfo-bin',
    'virtinst',
  ].each |String[1] $pkg| {
    package { $pkg:
      ensure => installed,
    }
  }

  file_capability { '/usr/lib/qemu/qemu-bridge-helper':
    capability => 'cap_net_admin+ep',
  }
}
