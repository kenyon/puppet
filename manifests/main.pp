util::lookup_filter('classes').include

stdlib::ensure_packages(util::lookup_filter('packages'), { ensure => installed })
stdlib::ensure_packages(util::lookup_filter('packages_absent'), { ensure => purged })

lookup('files', Hash, 'hash', {}).each |$key, $value| {
  file { $key:
    * => $value,
  }
}

lookup('file_lines', Hash, 'hash', {}).each |$key, $value| {
  file_line { $key:
    * => $value,
  }
}

lookup('ini_settings', Hash, 'hash', {}).each |$key, $value| {
  ini_setting { $key:
    * => $value,
  }
}

lookup('kernel_parameters', Hash, 'hash', {}).each |$key, $value| {
  kernel_parameter { $key:
    * => $value,
  }
}

lookup('services', Hash, 'hash', {}).each |$key, $value| {
  service { $key:
    * => $value,
  }
}

lookup('sshkeys', Hash, 'hash', {}).each |$key, $value| {
  sshkey { $key:
    * => $value,
  }
}

lookup('sysctls', Hash, 'hash', {}).each |$key, $value| {
  sysctl { $key:
    * => $value,
  }
}
