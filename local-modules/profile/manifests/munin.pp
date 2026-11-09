# @summary Munin configuration
class profile::munin {
  file { '/etc/apache2/munin.htpasswd':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => @("EOT"),
      munin:${apache::pw_hash('munin')}
      | EOT
  }
}
