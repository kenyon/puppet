# Configure hiera-eyaml for the Puppet Master server.

class mysite::roles::puppetmaster::hiera_eyaml (
  String $eyaml_private_key = '/etc/puppetlabs/puppet/eyaml/private_key.pem',
  String $eyaml_public_key  = '/etc/puppetlabs/puppet/eyaml/public_key.pem',
  String $eyaml_config      = '/etc/eyaml/config.yaml',
) {
  ensure_resources('file', {
    dirname($eyaml_private_key) => {},
    dirname($eyaml_public_key) => {},
  }, {
    ensure => directory,
    mode   => '0700',
    owner  => 'puppet',
    group  => 'puppet',
    before => Exec['eyaml createkeys'],
  })

  exec { 'eyaml createkeys':
    command => "eyaml createkeys --pkcs7-private-key=${eyaml_private_key} --pkcs7-public-key=${eyaml_public_key}",
    path    => '/usr/local/bin',
    creates => $eyaml_private_key,
    require => Package['gem_hiera-eyaml'],
  }

  file { [$eyaml_private_key, $eyaml_public_key]:
    ensure    => present,
    mode      => '0400',
    owner     => 'puppet',
    group     => 'puppet',
    subscribe => Exec['eyaml createkeys'],
  }

  file { dirname($eyaml_config):
    ensure => directory,
  }

  file { $eyaml_config:
    ensure  => present,
    content => "---
# This file is managed by puppet.
pkcs7_private_key: ${eyaml_private_key}
pkcs7_public_key: ${eyaml_public_key}
...\n",
  }
}
