# @summary Manage mail config
#
# @param postfix_sasl_passwd_content Content of `/etc/postfix/sasl/sasl_passwd`
class profile::mail (
  String[1] $postfix_sasl_passwd_content,
) {
  include postfix

  postfix::hash { '/etc/postfix/sasl/sasl_passwd':
    content => Sensitive("${postfix_sasl_passwd_content}\n"),
  }

  systemd::dropin_file { 'postfix.conf':
    unit    => 'postfix.service',
    content => @(EOT),
      # Managed by Puppet.
      [Service]
      Restart=on-failure
      | EOT
    require => Package['postfix'],
  }

  service { 'sendmail':
    ensure => stopped,
    enable => false,
  }
}
