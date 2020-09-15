class mysite::fqdn_in_etc_hosts {
  host { $trusted['certname']:
    host_aliases => $trusted['hostname'],
    ip           => '127.0.1.1',
  }
}
