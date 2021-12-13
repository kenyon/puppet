# @summary Manage debsums
class profile::debian::debsums {
  package { 'debsums':
    ensure => installed,
  }
  -> shellvar { 'CRON_CHECK':
    target => '/etc/default/debsums',
    value  => 'weekly',
  }
  # See /usr/share/doc/debsums/README.
  -> file { '/etc/debsums-ignore':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => @(EOT),
      ^/usr/share/applications/code-url-handler\.desktop$
      ^/usr/share/applications/code\.desktop$
      ^/var/lib/rkhunter/db/mirrors\.dat$
      | EOT
  }
}
