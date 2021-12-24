# @summary Manage puppet agent
class profile::puppet {
  if $facts['os']['family'] == 'FreeBSD' {
    ini_setting { 'puppet agent splay':
      path    => '/usr/local/etc/puppetlabs/puppet/puppet.conf',
      section => 'agent',
      setting => 'splay',
      value   => 'true',
    }

    ini_setting { 'puppet show_diff':
      path    => '/usr/local/etc/puppetlabs/puppet/puppet.conf',
      section => 'main',
      setting => 'show_diff',
      value   => 'true',
    }
  } else {
    include puppet_agent
  }

  $freebsd_path = $facts['os']['family'] ? {
    'FreeBSD' => '/usr/local',
    default   => undef,
  }

  file { "${freebsd_path}/etc/puppetlabs/facter":
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0755',
  }

  file { "${freebsd_path}/etc/puppetlabs/facter/facter.conf":
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => @(EOT),
      facts : {
          blocklist : [ "EC2" ],
      }
      | EOT
  }
}
