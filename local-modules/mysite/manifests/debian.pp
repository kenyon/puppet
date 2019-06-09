# -*- coding: utf-8 -*-
# Configuration common to Debian-family Linux machines.

class mysite::debian {
  # Ensure that apt is configured before any package
  # activities can happen.
  Apt::Conf <| |> -> Package <| |>
  Apt::Setting <| |> -> Package <| |>
}
