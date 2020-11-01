# -*- coding: utf-8 -*-
# Puppet code common to all hosts that I'm managing.

class mysite {
  mysite::lookup_filter('classes').include

  if mysite::is_linode() {
    include mysite::vms::kvm::linode
  }

  if mysite::is_vultr_vm() {
    include mysite::vms::kvm::vultr
  }

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

  lookup('ini_settings', Hash, 'hash', {}).each |$key, $value| {
    ini_setting { $key:
      * => $value,
    }
  }

  lookup('kenyon_dotfiles', Array, 'unique', []).each |$dotfile| {
    file { "/home/kenyon/${dotfile}":
      ensure  => link,
      owner   => 'kenyon',
      target  => "/home/kenyon/.puppet-managed/dotfiles/${dotfile}",
      require => Vcsrepo['/home/kenyon/.puppet-managed/dotfiles'],
    }
  }

  # Host-specific dotfiles.
  lookup('kenyon_host_dotfiles', Array, 'unique', []).each |$dotfile| {
    file { "/home/kenyon/${dotfile}":
      ensure  => link,
      owner   => 'kenyon',
      target  => "/home/kenyon/.puppet-managed/dotfiles/hosts/${trusted['hostname']}/${dotfile}",
      require => Vcsrepo['/home/kenyon/.puppet-managed/dotfiles'],
    }
  }

  lookup('postfix_configs', Hash, 'hash', {}).each |$key, $value| {
    postfix::config { $key:
      * => $value,
    }
  }

  lookup('postfix_hashes', Hash, 'hash', {}).each |$key, $value| {
    postfix::hash { $key:
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

  lookup('systemd_dropin_files', Hash, 'hash', {}).each |$key, $value| {
    systemd::dropin_file { $key:
      * => $value,
    }
  }

  lookup('vcsrepos', Hash, 'hash', {}).each |$key, $value| {
    vcsrepo { $key:
      * => $value,
    }
  }

  ensure_packages(mysite::lookup_filter('packages'),
                          {ensure => installed})

  ensure_packages(mysite::lookup_filter('packages_absent'),
                          {ensure => absent})

  Package['zsh'] -> User['kenyon']

  Package['ruby'] -> Package <| provider == 'gem' |>

  # Ruby gems.
  lookup('gems', Array[String], 'unique', []).each |String $gem| {
    package { "gem_${gem}":
      ensure   => installed,
      provider => gem,
      name     => $gem,
    }
  }

  lookup('npm_packages', Array[String], 'unique', []).each |String $pkg| {
    package { "npm_${pkg}":
      ensure   => present,
      provider => 'npm',
      name     => $pkg,
    }
  }
}
