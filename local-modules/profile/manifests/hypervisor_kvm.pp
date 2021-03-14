# @summary Configure things specific to a machine running a KVM hypervisor.
#
# @param file_capabilities
#   File capabilities required for KVM functionality. See capabilities(7).
#
# @param packages
#   Packages required for KVM functionality.
#
class profile::hypervisor_kvm (
  Array[String[1]] $packages,
  Hash $file_capabilities = {},
) {
  $file_capabilities.each |$path, $attrs| {
    file_capability { $path:
      * => $attrs,
    }
  }

  ensure_packages($packages, {ensure => installed})
}
