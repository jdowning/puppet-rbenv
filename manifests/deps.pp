# == Class: rbenv::deps
#
# This module manages rbenv dependencies.
#
# === Variables
#
# === Requires
#
# === Examples
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

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if ! defined(Package['git']) {
    package { 'git': }
  }

  case $::osfamily {
    'Debian': {
      include rbenv::deps::debian
      $group = 'adm'
    }
    'RedHat': {
      include rbenv::deps::redhat
      $group = 'whell'
    }
    'Suse': {
      include rbenv::deps::suse
      $group = 'users'
    }
    default:  { fail('The rbenv module currently only suports Debian, RedHat, and Suse families') }
  }
}
