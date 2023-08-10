# == Class: rbenv::deps::suse
#
# This module manages rbenv dependencies for suse $::osfamily.
#
class rbenv::deps::suse {
  ensure_packages([
      'automake',
      'binutils',
      'gcc',
      'gdbm-devel',
      'git',
      'libffi-devel',
      'libyaml-devel',
      'ncurses-devel',
      'openssl-devel',
      'patch',
      'readline-devel',
      'zlib-devel',
  ])
}
