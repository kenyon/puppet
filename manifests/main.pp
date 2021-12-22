util::lookup_filter('classes').include

ensure_packages(util::lookup_filter('packages'), {ensure => installed})
ensure_packages(util::lookup_filter('packages_absent'), {ensure => absent})

lookup('augeases', Hash, 'hash', {}).each |$key, $value| {
  augeas { $key:
    * => $value,
  }
}

lookup('concats', Hash, 'hash', {}).each |$key, $value| {
  concat { $key:
    * => $value,
  }
}

lookup('concat_fragments', Hash, 'hash', {}).each |$key, $value| {
  concat::fragment { $key:
    * => $value,
  }
}

lookup('cronjobs', Hash, 'hash', {}).each |$key, $value| {
  cron { $key:
    * => $value,
  }
}

lookup('execs', Hash, 'hash', {}).each |$key, $value| {
  exec { $key:
    * => $value,
  }
}

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

lookup('letsencrypt_certs', Hash, 'hash', {}).each |$key, $value| {
  letsencrypt::certonly { $key:
    * => $value,
  }
}

lookup('munin_plugins', Hash, 'hash', {}).each |$key, $value| {
  munin::plugin { $key:
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

lookup('shellvars', Hash, 'hash', {}).each |$key, $value| {
  shellvar { $key:
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

lookup('vcsrepos', Hash, 'hash', {}).each |$key, $value| {
  vcsrepo { $key:
    * => $value,
  }
}
