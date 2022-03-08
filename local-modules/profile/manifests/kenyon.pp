# @summary Manage stuff specific to my user environment
#
# @param dotfiles
#   Files to symlink in my homedir to the dotfiles git reop.
#
# @param groups
#   Groups to add my user to.
class profile::kenyon (
  Array[String[1]] $dotfiles = [],
  Array[String[1]] $groups = [],
) {
  include accounts
  include sudo

  $freebsd_path = $facts['os']['family'] ? {
    'FreeBSD' => '/usr/local',
    default   => undef,
  }

  accounts::user { 'kenyon':
    ignore_password_if_empty => true,
    password                 => '',
    comment                  => 'Kenyon Ralph',
    shell                    => "${freebsd_path}/bin/zsh",
    groups                   => $groups,
    managevim                => false,
    purge_sshkeys            => true,
    sshkeys                  => [
      'ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBG4GGrdvTXn6n9xcf9pdMKsjrrgyas176VEkBqN9Tw9IV9H2fEHFRkIKutaajss0OfI/KQqE8pmy220FshpWNwM= krPhoneSE',
      'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGZw6oCX3sFTBOnTJSrTPPzcmC2ygu+gxSM8CKuFK/S2 kenyon@iMac',
      'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDw7d1d4Lhxz7wv02IEUr8ssmc/BvCVEIzFgPko7haXx kenyon@stinkbook.local',
      'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOngf+NPCrcsHcmmqqmGQss1TrZS0VCue5KsXradcIqc ed25519-key-20210606-krPhoneSE-Shelly',
    ],
    require                  => Class['profile::zsh'],
  }
  -> file { '/home/kenyon/.config':
    ensure => directory,
    owner  => 'kenyon',
    mode   => '0700',
  }

  [
    'bin',
    '.bundle',
    '.config/git',
    '.puppet-managed',
  ].each |String[1] $dir| {
    file { "/home/kenyon/${dir}":
      ensure  => directory,
      owner   => 'kenyon',
      mode    => '0755',
      require => Accounts::User['kenyon'],
    }
  }

  [
    'dotfiles',
    'scripts',
  ].each |String[1] $repo| {
    vcsrepo { "/home/kenyon/.puppet-managed/${repo}":
      ensure   => latest,
      provider => git,
      source   => "https://gitlab.com/kenyon/${repo}.git",
      user     => 'kenyon',
      require  => [
        Accounts::User['kenyon'],
        File['/home/kenyon/.puppet-managed'],
      ],
    }
  }

  $dotfiles.each |String[1] $dotfile| {
    file { "/home/kenyon/${dotfile}":
      ensure  => link,
      owner   => 'kenyon',
      target  => "/home/kenyon/.puppet-managed/dotfiles/${dotfile}",
      require => Vcsrepo['/home/kenyon/.puppet-managed/dotfiles'],
    }
  }

  sudo::conf { 'kenyon':
    content => 'kenyon ALL = (ALL:ALL) NOPASSWD: ALL',
  }

  if fact('service_provider') == 'systemd' {
    loginctl_user { 'kenyon':
      linger  => enabled,
      require => Accounts::User['kenyon'],
    }
  }
}
