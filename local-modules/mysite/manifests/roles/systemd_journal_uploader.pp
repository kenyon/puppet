# systemd journal uploader

class mysite::roles::systemd_journal_uploader {
  ensure_packages(
    ['systemd-journal-remote'],
    {ensure => installed},
  )
}
