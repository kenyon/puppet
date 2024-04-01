# @summary Configuration for a Puppet Server
#   This is intended to be used on a node that was initially provisioned using my puppetserver
#   Ansible role: https://github.com/kenyon/ansible-playbooks
#
# @param r10k_deploy_settings
#   r10k deploy settings.
#
# @param puppetserver_gems
#   Ruby gems for the Puppet Server's embedded Ruby environment.
#
# @param r10k_remote
#   The URL of the control repo that r10k should deploy.
class profile::puppetserver (
  Hash $r10k_deploy_settings,
  String[1] $r10k_remote,
  Array[String[1]] $puppetserver_gems = [],
) {
  class { 'r10k':
    deploy_settings => $r10k_deploy_settings,
    remote          => $r10k_remote,
  }

  $puppetserver_gems.each |String $pkg| {
    package { "puppetserver_gem_${pkg}":
      ensure   => installed,
      name     => $pkg,
      provider => 'puppetserver_gem',
    }
  }

  # Provides /opt/puppetlabs/puppet/bin/puppet-query.
  # https://www.puppet.com/docs/puppetdb/latest/pdb_client_tools.html#step-2-install-and-configure-the-puppetdb-cli
  package { 'puppetdb_cli':
    ensure   => installed,
    provider => 'puppet_gem',
  }

  [
    'db',
    'query',
  ].each |String[1] $cmd| {
    file { "/opt/puppetlabs/bin/puppet-${cmd}":
      ensure => link,
      target => "../puppet/bin/puppet-${cmd}",
    }
  }

  file { '/etc/puppetlabs/client-tools':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/puppetlabs/client-tools/puppetdb.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => stdlib::to_json_pretty(
      {
        puppetdb => {
          server_urls => "https://${trusted['certname']}:8081",
          cacert      => $settings::localcacert,
          cert        => $settings::hostcert,
          key         => $settings::hostprivkey,
        },
      },
    ),
  }

  class { 'puppetboard':
    secret_key => stdlib::fqdn_rand_string(32),
  }
}
