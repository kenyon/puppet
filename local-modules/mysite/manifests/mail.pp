# My mail configuration.

class mysite::mail (Sensitive[String[1]] $sasl_passwd_hash) {
  # darwin has its own special configuration
  unless $trusted['hostname'] == 'darwin' {
    include postfix

    lookup('postfix_configs', Hash, 'hash', {}).each |$key, $value| {
      postfix::config { $key:
        * => $value,
      }
    }

    postfix::hash { '/etc/postfix/sasl/sasl_passwd':
      content => $sasl_passwd_hash,
    }
  }
}
