# @summary Manage cron
class profile::debian::cron {
  package { 'cron':
    ensure => installed,
  }
  -> shellvar { 'EXTRA_OPTS':
    target => '/etc/default/cron',
    value  => '-L 15',
  }
  ~> service { 'cron':
    ensure => running,
    enable => true,
  }
}
