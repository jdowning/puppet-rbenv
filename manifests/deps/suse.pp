# == Class: rbenv::deps::suse
#
# This module manages rbenv dependencies for suse $::osfamily.
#
class rbenv::deps::suse {

  ensure_packages([
    'binutils',
    'gcc',
    'git',
    'automake',
    'openssl-devel',
    'readline-devel',
    'zlib-devel',
    'libffi-devel',
    'libyaml-devel',
    'ncurses-devel',
    'gdbm-devel',
    'patch'
  ])
}
