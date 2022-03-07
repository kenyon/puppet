# @summary Manage apparmor
#
# @param profile_files
#   File resources for local apparmor profiles.
class profile::apparmor (
  Hash $profile_files = {},
) {
  # Linode kernels apparently don't support apparmor.
  unless util::is_linode() {
    package { 'apparmor':
      ensure => installed,
    }
    -> service { 'apparmor':
      enable => true,
    }

    $profile_files.each |$key, $value| {
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
}
