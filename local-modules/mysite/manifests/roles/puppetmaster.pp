# -*- coding: utf-8 -*-
# Configuration for the Puppet Master.

class mysite::roles::puppetmaster (Array[String] $puppetserver_gems) {
  # Ruby gems for the puppetserver embedded Ruby environment.
  $puppetserver_gems.each |String $pkg| {
    package { "puppetserver_gem_${pkg}":
      ensure          => installed,
      provider        => puppetserver_gem,
      name            => $pkg,
    }
  }
}
