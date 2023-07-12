# == Class: rbenv::deps::debian
#
# This module manages rbenv dependencies for Debian os family.
#
class rbenv::deps::debian (
  Array $packages = ['libgdbm6', 'libssl-dev']
) {
  $default_packages = [
    'build-essential',
    'git',
    'libreadline-dev',
    'zlib1g-dev',
    'libffi-dev',
    'libyaml-dev',
    'libncurses5-dev',
    'libgdbm-dev',
    'patch',
  ]
  $install_packages = flatten($default_packages, $packages)
  ensure_packages($install_packages)
}
