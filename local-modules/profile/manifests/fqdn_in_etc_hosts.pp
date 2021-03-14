# @summary Ensure that the FQDN is in /etc/hosts
#   This is the standard Debian way to do it. See hosts(5).
class profile::fqdn_in_etc_hosts {
  host { $trusted['certname']:
    host_aliases => $trusted['hostname'],
    ip           => $facts['networking']['ip6'],
  }
}
