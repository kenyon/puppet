# -*- coding: utf-8 -*-
# Configure things specific to VMs running under KVM (except Linodes).

class mysite::vms::kvm {
  include ::kmod

  class { '::chrony':
    servers   => [],
    # Special refclock that syncs the VM clock with the host system
    # clock. Requires kernel config PTP_1588_CLOCK_KVM, which is a
    # module (ptp_kvm) in RHEL 7, compiled-in in Debian's
    # stretch-backports kernel, and not available in Debian stretch
    # standard kernel package.
    refclocks => ['PHC /dev/ptp0 poll 3 dpoll -2 offset 0'],
  }

  kmod::load { 'ptp_kvm':
    before => Service['chrony'],
  }

  stdlib::ensure_packages(
    ['qemu-guest-agent'],
    {ensure => installed},
  )

  # This systemd service allows for accessing the VM's serial console
  # using "virsh console <domain>".
  service { 'serial-getty@ttyS0':
    ensure => true,
    enable => true,
  }
}
