# -*- coding: utf-8 -*-
# Puppet code common to all hosts that I'm managing.

class mysite {
  mysite::lookup_filter('classes').include

  create_resources('accounts::user',  lookup('users',           Hash, 'deep'))
  create_resources(group,             lookup('groups',          Hash, 'deep'))
  create_resources(augeas,            lookup('augeases',        Hash, 'hash'))
  create_resources(cron,              lookup('cronjobs',        Hash, 'hash'))
  create_resources(exec,              lookup('execs',           Hash, 'hash'))
  create_resources(file,              lookup('files',           Hash, 'hash'))
  create_resources('file_line',       lookup('file_lines',      Hash, 'hash'))
  create_resources(service,           lookup('services',        Hash, 'hash'))
  create_resources(sysctl,            lookup('sysctls',         Hash, 'hash'))
  create_resources('postfix::config', lookup('postfix_configs', Hash, 'hash'))
  create_resources('postfix::hash',   lookup('postfix_hashes',  Hash, 'hash'))

  ensure_packages(mysite::lookup_filter('packages'),
                          {ensure => installed})

  ensure_packages(mysite::lookup_filter('packages_absent'),
                          {ensure => absent})

  Package['ruby'] -> Package <| provider == 'gem' |>

  # Ruby gems.
  lookup('gems', Array[String], 'unique').each |String $gem| {
    package { "gem_${gem}":
      ensure          => installed,
      provider        => gem,
      name            => $gem,
    }
  }
}
