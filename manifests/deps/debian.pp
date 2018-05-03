# == Class: rbenv::deps::debian
#
# This module manages rbenv dependencies for Debian $::osfamily.
#
class rbenv::deps::debian {
  $libgdbm = $::lsbdistcodename ? {
    'bionic'           => 'libgdbm5',
    default            => 'libgdbm3',
  }
  ensure_packages([
    'build-essential',
    'git',
    'libreadline-dev',
    'libssl-dev',
    'zlib1g-dev',
    'libffi-dev',
    'libyaml-dev',
    'libncurses5-dev',
    $libgdbm,
    'libgdbm-dev',
    'patch'
    ])
}
