class mysite::fqdn_in_etc_hosts {
  host { $trusted['certname']:
    host_aliases => $trusted['hostname'],
    ip           => $facts['networking']['ip6'],
  }
}
