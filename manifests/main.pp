util::lookup_filter('classes').include

ensure_packages(util::lookup_filter('packages'), { ensure => installed })
ensure_packages(util::lookup_filter('packages_absent'), { ensure => absent })

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

lookup('npm_packages', Array[String], 'unique', []).each |String $pkg| {
  package { "npm_${pkg}":
    ensure   => present,
    provider => 'npm',
    name     => $pkg,
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
