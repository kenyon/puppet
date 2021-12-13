# @summary Manage apt-listchanges
class profile::debian::apt_listchanges {
  package { 'apt-listchanges':
    ensure => installed,
  }

  ini_setting { 'apt-listchanges confirm':
    path    => '/etc/apt/listchanges.conf',
    section => 'apt',
    setting => 'confirm',
    value   => 'yes',
    require => Package['apt-listchanges'],
  }

  ini_setting { 'apt-listchanges which':
    path    => '/etc/apt/listchanges.conf',
    section => 'apt',
    setting => 'which',
    value   => 'both',
    require => Package['apt-listchanges'],
  }
}
