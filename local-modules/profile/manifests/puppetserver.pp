# @summary Configuration for a Puppet Server
#   This is intended to be used on a node that was initially provisioned using my puppetserver
#   Ansible role: https://github.com/kenyon/ansible-playbooks
#
# @param puppetserver_gems
#   Ruby gems for the Puppet Server's embedded Ruby environment.
#
# @param r10k_deploy_settings
#   r10k deploy settings.
#
# @param r10k_remote
#   The URL of the control repo that r10k should deploy.
#
# @param r10k_webhook_token
#   The token for the webhook to use.
#
# @param r10k_webhook_enable_ssl
#   Whether to use TLS with the webhook.
#
# @param r10k_webhook_group
#   The group the webhook should run as.
#
# @param r10k_webhook_user
#   The user the webhook should run as.
#
# @param r10k_webhook_protected
#
# @param r10k_webhook_access_logfile
#
class profile::puppetserver (
  Array[String[1]] $puppetserver_gems,
  Hash $r10k_deploy_settings,
  String[1] $r10k_remote,
  String[1] $r10k_webhook_token,
  Boolean $r10k_webhook_enable_ssl = false,
  String[1] $r10k_webhook_group = 'root',
  String[1] $r10k_webhook_user = 'root',
  Boolean $r10k_webhook_protected = false,
  Variant[Stdlib::Absolutepath, Enum['stderr']] $r10k_webhook_access_logfile = 'stderr',
) {
  class { 'r10k::config':
    deploy_settings => $r10k_deploy_settings,
    remote          => $r10k_remote,
  }

  class { 'r10k::webhook':
    use_mcollective => false,
    group           => $r10k_webhook_group,
    user            => $r10k_webhook_user,
  }

  class { 'r10k::webhook::config':
    access_logfile  => $r10k_webhook_access_logfile,
    enable_ssl      => $r10k_webhook_enable_ssl,
    use_mcollective => false,
    gitlab_token    => $r10k_webhook_token,
    protected       => $r10k_webhook_protected,
  }

  $puppetserver_gems.each |String $pkg| {
    package { "puppetserver_gem_${pkg}":
      ensure   => installed,
      name     => $pkg,
      provider => 'puppetserver_gem',
    }
  }
}
