# Configure things related to being a DNS server.

class mysite::roles::dns_server {
  ensure_packages(
    ['bind9', 'dns-root-data'],
    {ensure => installed},
  )

  service { 'bind9':
    ensure => running,
  }
}
