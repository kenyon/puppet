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
}
