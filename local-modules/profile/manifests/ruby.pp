# @summary Manage ruby
class profile::ruby {
  $freebsd_path = $facts['os']['family'] ? {
    'FreeBSD' => '/usr/local',
    default   => undef,
  }

  package { 'ruby':
    ensure => installed,
  }
  -> file { "${freebsd_path}/etc/gemrc":
    ensure  => file,
    content => @(EOT),
      # Managed by Puppet
      gem: --user-install
      install: --no-document
      update: --no-document
      | EOT
  }

  lookup('gems', Array[String], 'unique', []).each |String $gem| {
    package { "gem_${gem}":
      ensure   => installed,
      provider => gem,
      name     => $gem,
      require  => Package['ruby'],
    }
  }
}
