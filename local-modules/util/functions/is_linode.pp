function util::is_linode >> Boolean {
  $facts['kernelrelease'] =~ /linode/
}
