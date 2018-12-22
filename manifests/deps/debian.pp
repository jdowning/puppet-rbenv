# == Class: rbenv::deps::debian
#
# This module manages rbenv dependencies for Debian $::osfamily.
#
class rbenv::deps::debian {
  $libgdbm_package_name = $::os['distro']['codename'] ? {
    'bionic' => 'libgdbm5',
    default  => 'libgdbm3',
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
    $libgdbm_package_name,
    'libgdbm-dev',
    'patch'
    ])
}
