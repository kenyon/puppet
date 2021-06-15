# @summary Manage multitail
class profile::multitail {
  package { 'multitail':
    ensure => installed,
  }
  -> file { '/etc/multitail.conf':
    ensure  => file,
    content => file("${module_name}/etc/multitail.conf"),
  }
}
