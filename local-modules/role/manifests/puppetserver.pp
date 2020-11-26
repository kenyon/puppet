# -*- coding: utf-8 -*-
# Configuration for a Puppet Server.

class role::puppetserver (
  Array[String] $classes,
  Array[String] $gems,
  Hash          $logrotate_rules,
  Array[String] $packages,
  Array[String] $puppetserver_gems,
  Hash          $r10k_deploy_settings,
  String[1]     $r10k_remote,
  Boolean       $r10k_webhook_enable_ssl,
  String[1]     $r10k_webhook_group,
  String[1]     $r10k_webhook_token,
  String[1]     $r10k_webhook_user,
  Boolean       $r10k_webhook_use_mcollective,
  Boolean       $r10k_webhook_protected,
) {
  $classes.each |String $cls| {
    include $cls
  }

  class { 'logrotate':
    rules => $logrotate_rules,
  }

  class { 'r10k::config':
    deploy_settings => $r10k_deploy_settings,
    remote          => $r10k_remote,
  }

  class { 'r10k::webhook':
    use_mcollective => $r10k_webhook_use_mcollective,
    group           => $r10k_webhook_group,
    user            => $r10k_webhook_user,
  }

  class { 'r10k::webhook::config':
    enable_ssl      => $r10k_webhook_enable_ssl,
    use_mcollective => $r10k_webhook_use_mcollective,
    gitlab_token    => $r10k_webhook_token,
    protected       => $r10k_webhook_protected,
  }

  ensure_packages($packages, {ensure => installed})

  $gems.each |String $gem| {
    package { "gem_${gem}":
      ensure   => installed,
      name     => $gem,
      provider => 'gem',
    }
  }

  $puppetserver_gems.each |String $pkg| {
    package { "puppetserver_gem_${pkg}":
      ensure   => installed,
      name     => $pkg,
      provider => 'puppetserver_gem',
    }
  }
}
