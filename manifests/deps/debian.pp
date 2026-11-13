# == Class: rbenv::deps::debian
#
# This module manages rbenv dependencies for Debian os family.
#
# === Variable
#
# @param packages
#   This is used to specify additional packages to install.
#   Default: ['libgdbm6', 'libssl-dev']
#   This variable is optional.
#
class rbenv::deps::debian (
  Array $packages = ['libgdbm6', 'libssl-dev', 'libncurses5-dev']
) {
  $default_packages = [
    'build-essential',
    'git',
    'libreadline-dev',
    'zlib1g-dev',
    'libffi-dev',
    'libyaml-dev',
    'libgdbm-dev',
    'patch',
  ]
  $install_packages = flatten($default_packages, $packages)
  stdlib::ensure_packages($install_packages)
}
