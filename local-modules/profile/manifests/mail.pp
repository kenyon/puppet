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
}
