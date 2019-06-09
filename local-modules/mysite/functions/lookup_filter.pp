# Implemented this function because of bugs:
# https://tickets.puppetlabs.com/browse/HI-223
# https://tickets.puppetlabs.com/browse/PUP-7428
# https://tickets.puppetlabs.com/browse/PUP-8405

# Does a hiera lookup for the given key, which must be an
# array of strings, and returns an array of strings with items
# merged from all hiera data sources as usual, with items
# filtered out which are prefixed with '--'.

function mysite::lookup_filter(String $key) >> Array[String] {
  $everything = lookup($key, Array[String], 'unique')
  # can't interpolate variables into regexes :(
  $removals_prefixed = $everything.filter |$item| { $item =~ /^--/ }
  $removals = $removals_prefixed.map |$item| { regsubst($item, /^--/, '') }
  $everything - $removals - $removals_prefixed
}
