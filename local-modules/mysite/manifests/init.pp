# -*- coding: utf-8 -*-
# Puppet code common to all hosts that I'm managing.

class mysite {
  mysite::lookup_filter('classes').include

  lookup('augeases', Hash, 'hash', {}).each |$key, $value| {
    augeas { $key:
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

  lookup('postfix_configs', Hash, 'hash', {}).each |$key, $value| {
    ::postfix::config { $key:
      * => $value,
    }
  }

  lookup('postfix_hashes', Hash, 'hash', {}).each |$key, $value| {
    ::postfix::hash { $key:
      * => $value,
    }
  }

  lookup('services', Hash, 'hash', {}).each |$key, $value| {
    service { $key:
      * => $value,
    }
  }

  lookup('sysctls', Hash, 'hash', {}).each |$key, $value| {
    sysctl { $key:
      * => $value,
    }
  }

  ensure_packages(mysite::lookup_filter('packages'),
                          {ensure => installed})

  ensure_packages(mysite::lookup_filter('packages_absent'),
                          {ensure => absent})

  Package['ruby'] -> Package <| provider == 'gem' |>

  # Ruby gems.
  lookup('gems', Array[String], 'unique', []).each |String $gem| {
    package { "gem_${gem}":
      ensure          => installed,
      provider        => gem,
      name            => $gem,
    }
  }
}
