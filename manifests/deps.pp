# == Class: rbenv::deps
#
# This module manages rbenv dependencies and should *not* be called directly.
#
# === Authors
#
# Justin Downing <justin@downing.us>
#
# === Copyright
#
# Copyright 2013 Justin Downing
#
class rbenv::deps {
  case $::osfamily {
    'Debian': {
      include rbenv::deps::debian
    }
    'RedHat': {
      include rbenv::deps::redhat
    }
    'Suse': {
      include rbenv::deps::suse
    }
    default: {
      fail('The rbenv module currently only suports Debian, RedHat, and Suse.')
    }
  }
}
