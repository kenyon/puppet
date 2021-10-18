# @summary My mail configuration
class profile::mail {
  # darwin is the main mail server and so has its own special configuration.
  unless $trusted['hostname'] == 'darwin' {
    include postfix
  }
}
