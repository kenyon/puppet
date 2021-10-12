# @summary Configure avahi
class profile::avahi {
  package { 'avahi-autoipd':
    ensure => installed,
  }

  # Disable the DHCP hook actions.
  [
    '/etc/dhcp/dhclient-enter-hooks.d/avahi-autoipd',
    '/etc/dhcp/dhclient-exit-hooks.d/zzz_avahi-autoipd',
  ].each |Stdlib::Absolutepath $file| {
    file { $file:
      ensure => absent,
    }
  }

  # Disable the route-change hook scripts.
  [
    '/etc/network/if-up.d/avahi-autoipd',
    '/etc/network/if-down.d/avahi-autoipd',
  ].each |Stdlib::Absolutepath $file| {
    file { $file:
      ensure => absent,
    }
  }

  systemd::unit_file { 'avahi-autoipd@.service':
    content => @(EOF)
      [Unit]
      Description=Avahi IPv4LL network address configuration daemon

      [Service]
      ExecStart=/usr/sbin/avahi-autoipd --force-bind %I
      ExecReload=/usr/sbin/avahi-autoipd --refresh %I
      ExecStop=/usr/sbin/avahi-autoipd --kill %I

      [Install]
      WantedBy=network.target
      |EOF
  }
  ~> service { "avahi-autoipd@${facts['networking']['primary']}":
    ensure  => running,
    enable  => true,
    require => Package['avahi-autoipd'],
  }
}
