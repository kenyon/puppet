# Configure things related to being a DNS server.

class mysite::roles::dns_server {
  ensure_packages(
    ['bind9'],
    {ensure => installed},
  )

  service { 'bind9':
    ensure => running,
  }

  file { '/etc/bind/db.root':
    ensure => file,
    source => 'https://www.internic.net/domain/named.root',
    notify => Service['bind9'],
  }
}
