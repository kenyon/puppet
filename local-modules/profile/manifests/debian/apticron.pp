# @summary Manage apticron
class profile::debian::apticron {
  require profile::debian::cron

  package { 'apticron':
    ensure => installed,
  }
}
