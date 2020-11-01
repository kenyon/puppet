# -*- coding: utf-8 -*-
# Configuration for the Puppet Master.

class role::puppetmaster (Array[String] $puppetserver_gems) {
  include puppetdb
  include puppetdb::master::config
  include r10k::config
  include r10k::webhook
  include r10k::webhook::config
  include role::puppetmaster::hiera_eyaml
  include logrotate

  # Ruby gems for the puppetserver embedded Ruby environment.
  $puppetserver_gems.each |String $pkg| {
    package { "puppetserver_gem_${pkg}":
      ensure   => installed,
      provider => puppetserver_gem,
      name     => $pkg,
    }
  }
}
