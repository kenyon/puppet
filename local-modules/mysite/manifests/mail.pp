# My mail configuration.

class mysite::mail {
  # darwin has its own special configuration
  unless $trusted['hostname'] == 'darwin' {
    include postfix

    lookup('postfix_configs', Hash, 'hash', {}).each |$key, $value| {
      postfix::config { $key:
        * => $value,
      }
    }

    lookup('postfix_hashes', Hash, 'hash', {}).each |$key, $value| {
      postfix::hash { $key:
        * => $value,
      }
    }
  }
}
