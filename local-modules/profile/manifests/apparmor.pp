# @summary Manage apparmor
#
# @param profile_files
#   File resources for local apparmor profiles.
class profile::apparmor (
  Hash $profile_files = {},
) {
  package { 'apparmor':
    ensure => installed,
  }
  -> service { 'apparmor':
    enable => true,
  }

  $profile_files.each |String[1] $key, Hash $value| {
    file { "/etc/apparmor.d/local/${key}":
      ensure => file,
      owner  => root,
      group  => root,
      mode   => '0644',
      notify => Service['apparmor'],
      *      => $value,
    }
  }
}
