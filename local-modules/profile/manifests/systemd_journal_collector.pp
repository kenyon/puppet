# @summary systemd journal collector
#
class profile::systemd_journal_collector {
  package { 'systemd-journal-remote':
    ensure => installed,
  }

  service { 'systemd-journal-remote':
    ensure  => running,
    enable  => true,
    require => Package['systemd-journal-remote'],
  }

  systemd::dropin_file { 'systemd-journal-remote.conf':
    unit    => 'systemd-journal-remote.service',
    content => @(CONF),
      # Managed by Puppet
      [Service]
      ExecStart=
      ExecStart=/lib/systemd/systemd-journal-remote --listen-http=-3
      | CONF
    notify  => Service['systemd-journal-remote'],
  }
}
