# systemd journal collector

class mysite::roles::systemd_journal_collector {
  ensure_packages(
    ['systemd-journal-remote'],
    {ensure => installed},
  )
}
