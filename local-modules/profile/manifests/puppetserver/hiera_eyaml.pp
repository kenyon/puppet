# @summary Configure hiera-eyaml for a Puppet server
#
# @param eyaml_private_key
#   Path to the eyaml private key.
#
# @param eyaml_public_key
#   Path to the eyaml public key.
#
# @param eyaml_config
#   Path to the eyaml config.
#
class profile::puppetserver::hiera_eyaml (
  Stdlib::Absolutepath $eyaml_private_key = '/etc/puppetlabs/puppet/eyaml/private_key.pem',
  Stdlib::Absolutepath $eyaml_public_key  = '/etc/puppetlabs/puppet/eyaml/public_key.pem',
  Stdlib::Absolutepath $eyaml_config      = '/etc/eyaml/config.yaml',
) {
  ensure_resources('file', {
    dirname($eyaml_private_key) => {},
    dirname($eyaml_public_key) => {},
  }, {
      ensure  => directory,
      mode    => '0700',
      owner   => 'puppet',
      group   => 'puppet',
      before  => Exec['eyaml createkeys'],
      require => Package['puppetserver'],
  })

  exec { 'eyaml createkeys':
    command => "/usr/local/bin/eyaml createkeys --pkcs7-private-key=${eyaml_private_key} --pkcs7-public-key=${eyaml_public_key}",
    creates => $eyaml_private_key,
    require => Package['gem_hiera-eyaml'],
  }

  [$eyaml_private_key, $eyaml_public_key].each |$file| {
    file { $file:
      ensure    => present,
      mode      => '0400',
      owner     => 'puppet',
      group     => 'puppet',
      subscribe => Exec['eyaml createkeys'],
    }
  }

  file { dirname($eyaml_config):
    ensure => directory,
  }

  file { $eyaml_config:
    ensure  => present,
    content => @("CONF"),
      ---
      # This file is managed by puppet.
      pkcs7_private_key: ${eyaml_private_key}
      pkcs7_public_key: ${eyaml_public_key}
      | CONF
  }
}
