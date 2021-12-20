# @summary Manage multitail
class profile::multitail {
  $freebsd_path = $facts['os']['family'] ? {
    'FreeBSD' => '/usr/local',
    default   => undef,
  }

  package { 'multitail':
    ensure => installed,
  }
  -> file { "${freebsd_path}/etc/multitail.conf":
    ensure  => file,
    content => file("${module_name}/etc/multitail.conf"),
  }
}
