# -*- coding: utf-8 -*-
# Configuration common to RedHat-famly Linux machines.

class mysite::redhat {
  # FIXME: replace with dnf equivalents

  # On RHEL, ensure that subscription-manager is configured
  # before yum is configured.
  # if $facts['os']['name'] == 'RedHat' {
  #   Rhsm::Repo <| |> -> Yum::Config <| |>
  # }

  # Ensure that yum is configured before any package activities can
  # happen. Excluding subscription-manager because otherwise this
  # creates a dependency cycle.
  #Yum::Config <| |> -> Package <| title != 'subscription-manager' |>

  #Package['yum-cron'] -> Service['yum-cron']

  # lookup('yumrepos', Hash, 'hash', {}).each |$key, $value| {
  #   yumrepo { $key:
  #     * => $value,
  #   }
  # }
}
