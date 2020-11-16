# -*- coding: utf-8 -*-
# Configure things specific to VMs running under KVM.

class mysite::vms::kvm (
  Boolean $enable_serial_console = true,
  Boolean $install_qemu_guest_agent = true,
) {
  # Linode kernels have CONFIG_PTP_1588_CLOCK and
  # CONFIG_PTP_1588_CLOCK_KVM built in (not as modules).
  unless mysite::is_linode() {
    include kmod
    kmod::load { 'ptp_kvm':
      before => Service['chrony'],
    }
  }

  # Don't install this on Linodes, it just hangs when it starts.
  # Also don't need this on Vultr VMs.
  if $install_qemu_guest_agent
  and !mysite::is_linode()
  and !mysite::is_vultr_vm() {
    ensure_packages(
      ['qemu-guest-agent'],
      {ensure => installed},
    )
  }

  # Linodes don't need to set up serial console (can access console
  # through Linode's web interface). Same with Vultr VMs.
  if $enable_serial_console
  and !mysite::is_linode()
  and !mysite::is_vultr_vm() {
    # This systemd service allows for accessing the VM's serial console
    # using "virsh console <domain>".
    service { 'serial-getty@ttyS0':
      ensure => true,
      enable => true,
    }
  }
}
