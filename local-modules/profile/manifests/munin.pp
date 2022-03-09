# @summary Manage some munin configuration that's not in hiera
class profile::munin {
  munin::plugin { 'puppet_runtime':
    ensure  => present,
    config  => [
      'user root',
    ],
    content => file("${module_name}/munin/puppet_runtime"),
  }
}
