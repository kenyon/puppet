# @summary Configure things specific to VMs running under KVM
#
# @param enable_serial_console
#   Whether to enable virtual serial console.
#
# @param ensure_qemu_guest_agent
#   The `ensure` parameter for the qemu-guest-agent package.
#
class profile::vms::kvm (
  Boolean $enable_serial_console = true,
  String[1] $ensure_qemu_guest_agent = installed,
) {
  include kmod

  kmod::load { 'ptp_kvm':
    before => Class['profile::timesync'],
  }

  if util::is_linode() {
    include profile::vms::kvm::linode
  } elsif util::is_vultr_vm() {
    include profile::vms::kvm::vultr
  } else {
    # Don't install this on Linodes, it just hangs when it starts.
    # Also don't need this on Vultr VMs.
    package { 'qemu-guest-agent':
      ensure => $ensure_qemu_guest_agent,
    }

    # Linodes don't need to set up serial console (can access console
    # through Linode's web interface). Same with Vultr VMs.
    # This systemd service allows for accessing the VM's serial console
    # using "virsh console <domain>".
    service { 'serial-getty@ttyS0':
      ensure => stdlib::ensure($enable_serial_console, 'service'),
      enable => $enable_serial_console,
    }
  }
}
