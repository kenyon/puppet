# @summary Manage puppet agent
class profile::puppet {
  include puppet

  Apt::Source['openvox'] -> Class['apt::update'] -> Class['Puppet::Agent::Install']

  file { '/etc/default/puppet':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => @(EOT),
      # Managed by Puppet
      PUPPET_EXTRA_OPTS=
      | EOT
    notify  => Class['Puppet::Agent::Service'],
  }
}
