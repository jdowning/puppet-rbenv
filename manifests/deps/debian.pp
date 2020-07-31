# == Class: rbenv::deps::debian
#
# This module manages rbenv dependencies for Debian $::osfamily.
#
class rbenv::deps::debian {
  $packages = $::lsbdistcodename ? {
    'buster'           => [ 'libgdbm6', 'libssl-dev' ],
    'bionic'           => [ 'libgdbm5', 'libssl1.0-dev' ],
    default            => [ 'libgdbm3', 'libssl-dev']
  }
  $default_packages = [
    'build-essential',
    'git',
    'libreadline-dev',
    'zlib1g-dev',
    'libffi-dev',
    'libyaml-dev',
    'libncurses5-dev',
    'libgdbm-dev',
    'patch'
  ]
  $install_packages = flatten($default_packages, $packages)
  ensure_packages($install_packages)

}
