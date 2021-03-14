# @summary My mail configuration
#
# @param postfix_configs
#   Postfix configuration key-value hash.
#
# @param sasl_passwd_hash
#   The content of /etc/postfix/sasl/sasl_passwd, which is used for authenticating to the main mail
#   server for submitting mail.
#
class profile::mail (
  Sensitive[String[1]] $sasl_passwd_hash,
  Hash $postfix_configs = {},
) {
  # darwin is the main mail server and so has its own special configuration.
  unless $trusted['hostname'] == 'darwin' {
    include postfix

    $postfix_configs.each |$key, $value| {
      postfix::config { $key:
        * => $value,
      }
    }

    postfix::hash { '/etc/postfix/sasl/sasl_passwd':
      content => $sasl_passwd_hash,
    }
  }
}
