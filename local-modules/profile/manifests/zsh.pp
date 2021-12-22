# @summary Manage zsh
class profile::zsh {
  $freebsd_path = $facts['os']['family'] ? {
    'FreeBSD' => '/usr/local',
    default   => undef,
  }

  [
    'zsh-autosuggestions',
    'zsh-syntax-highlighting',
    'zsh',
  ].each |String[1] $pkg| {
    package { $pkg:
      ensure => installed,
    }
  }

  file { "${freebsd_path}/etc/zlogout":
    ensure => absent,
  }
}
