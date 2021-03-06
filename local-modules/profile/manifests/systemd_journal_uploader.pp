# @summary systemd journal uploader
#
class profile::systemd_journal_uploader {
  package { 'systemd-journal-remote':
    ensure => installed,
  }

  service { 'systemd-journal-upload':
    ensure  => running,
    enable  => true,
    require => Package['systemd-journal-remote'],
  }

  ini_setting { 'systemd_journal_upload_url':
    ensure  => present,
    path    => '/etc/systemd/journal-upload.conf',
    section => 'Upload',
    setting => 'URL',
    value   => 'http://journal.kenyonralph.com',
    notify  => Service['systemd-journal-upload'],
  }
}
