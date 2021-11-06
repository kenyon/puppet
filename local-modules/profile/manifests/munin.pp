# @summary Manage some munin configuration that's not in hiera
class profile::munin {
  munin::plugin { 'puppet_runtime':
    ensure => present,
    config => [
      'user root',
    ],
    source => "puppet:///modules/${module_name}/munin/puppet_runtime",
  }
}
