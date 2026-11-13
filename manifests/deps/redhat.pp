# == Class: rbenv::deps::redhat
#
# This module manages rbenv dependencies for redhat $::osfamily.
#
class rbenv::deps::redhat {
  stdlib::ensure_packages([
      'binutils',
      'bzip2',
      'gcc',
      'gcc-c++',
      'git',
      'make',
      'openssl-devel',
      'readline-devel',
      'zlib-devel',
      'libffi-devel',
      'libyaml-devel',
      'ncurses-devel',
      'gdbm-devel',
      'patch',
  ])
}
