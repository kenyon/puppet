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
}
