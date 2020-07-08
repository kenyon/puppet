# systemd journal collector

class mysite::roles::systemd_journal_collector {
  ensure_packages(
    ['systemd-journal-remote'],
    {ensure => installed},
  )

  service { 'systemd-journal-remote':
    ensure  => 'running',
    enable  => true,
    require => Package['systemd-journal-remote'],
  }

  systemd::dropin_file { 'systemd-journal-remote.conf':
    unit    => 'systemd-journal-remote.service',
    source => "puppet:///modules/${module_name}/systemd-journal-remote.conf",
    notify  => Service['systemd-journal-remote'],
  }
}
