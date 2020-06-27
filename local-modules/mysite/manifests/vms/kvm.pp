# -*- coding: utf-8 -*-
# Configure things specific to VMs running under KVM.

class mysite::vms::kvm (
  Boolean $enable_serial_console = true,
  Boolean $install_qemu_guest_agent = true,
) {
  include ::kmod

  ensure_packages(
    ['ntp'],
    {ensure => absent},
  )

  if $facts['os']['distro']['codename'] == 'stretch' {
    apt::pin { 'backports_kernel':
      packages => 'linux-image-amd64',
      priority => 500,
      release  => 'stretch-backports',
    }

    ensure_packages(
      ['linux-image-amd64'],
      {ensure => latest},
    )
  }

  class { '::chrony':
    servers    => [],
    pools      => '2.pool.ntp.org',
    # Special refclock that syncs the VM clock with the host system
    # clock. Requires kernel config PTP_1588_CLOCK_KVM, which is a
    # module (ptp_kvm) in RHEL 7 and a module in Debian buster.
    refclocks  => ['PHC /dev/ptp_kvm poll 3 dpoll -2 stratum 2'],
    port       => '123',
    queryhosts => '',
  }

  # Linode kernels have CONFIG_PTP_1588_CLOCK and
  # CONFIG_PTP_1588_CLOCK_KVM built in (not as modules).
  unless mysite::is_linode() {
    kmod::load { 'ptp_kvm':
      before => Service['chrony'],
    }
  }

  # Don't install this on Linodes, it just hangs when it starts.
  if $install_qemu_guest_agent and !mysite::is_linode() {
    ensure_packages(
      ['qemu-guest-agent'],
      {ensure => installed},
    )
  }

  # Linodes don't need to set up serial console (can access console
  # through Linode's web interface).
  if $enable_serial_console and !mysite::is_linode() {
    # This systemd service allows for accessing the VM's serial console
    # using "virsh console <domain>".
    service { 'serial-getty@ttyS0':
      ensure => true,
      enable => true,
    }
  }
}
