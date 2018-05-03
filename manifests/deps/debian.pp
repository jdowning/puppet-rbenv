# == Class: rbenv::deps::debian
#
# This module manages rbenv dependencies for Debian $::osfamily.
#
class rbenv::deps::debian {
  $packages = $::lsbdistcodename ? {
    'bionic'           => [ 'libgdbm5', 'libssl1.0-dev' ],
    default            => [ 'libgdbm3', 'libssl-dev']
  }
  ensure_packages([
    'build-essential',
    'git',
    'libreadline-dev',
    'zlib1g-dev',
    'libffi-dev',
    'libyaml-dev',
    'libncurses5-dev',
    'libgdbm-dev',
    $packages,
    'patch'
    ])
}
