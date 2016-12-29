# == Class: rbenv::params
#
# This class manages per-osfamily rbenv settings and should *not* be called directly.
#
# === Authors
#
# Justin Downing <justin@downing.us>
#
# === Copyright
#
# Copyright 2013 Justin Downing
#
class rbenv::params {
  case $::osfamily {
    'Debian': {
      $group = 'adm'
    }
    'RedHat': {
      $group = 'wheel'
    }
    'Suse': {
      $group = 'users'
    }
    default: {
      fail('The rbenv module currently only suports Debian, RedHat, and Suse.')
    }
  }
}
