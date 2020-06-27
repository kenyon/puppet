function mysite::is_linode >> Boolean {
  $facts['kernelrelease'] =~ /linode/
}
