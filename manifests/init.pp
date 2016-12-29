# == Class: rbenv
#
# This module manages rbenv on Ubuntu. The default installation directory
# allows rbenv to available for all users and applications.
#
# === Variables
#
# [$repo_path]
#   This is the git repo used to install rbenv.
#   Default: 'https://github.com/rbenv/rbenv.git'
#   This variable is required.
#
# [$install_dir]
#   This is where rbenv will be installed to.
#   Default: '/usr/local/rbenv'
#   This variable is required.
#
# [$owner]
#   This defines who owns the rbenv install directory.
#   Default: 'root'
#   This variable is required.
#
# [$group]
#   This defines the group membership for rbenv.
#   Default: 'adm'
#   This variable is required.
#
# [$latest]
#   This defines whether the rbenv $install_dir is kept up-to-date.
#   Defaults: false
#   This variable is optional.
#
# [$version]
#   This checks out the specified version of rbenv to $install_dir.
#   Defaults: undef
#   This variable is optional and has no affect if latest is true.
#
# [$env]
#   This is used to set environment variables when compiling ruby.
#   Default: []
#   This variable is optional.
#
# [$manage_deps]
#   Toggles the option to let module manage dependencies or not.
#   Default: true
#   This variable is optional.
#
# === Requires
#
# This module requires the following modules:
#   'puppetlabs/stdlib' >= 4.1.0
#
# === Examples
#
# class { rbenv: }  #Uses the default parameters
#
# class { rbenv:  #Uses a user-defined installation path
#   install_dir => '/opt/rbenv',
# }
#
# More information on using Hiera to override parameters is available here:
#   http://docs.puppetlabs.com/hiera/1/puppet.html#automatic-parameter-lookup
#
# === Authors
#
# Justin Downing <justin@downing.us>
#
# === Copyright
#
# Copyright 2013 Justin Downing
#
class rbenv (
  $repo_path   = 'https://github.com/rbenv/rbenv.git',
  $install_dir = '/usr/local/rbenv',
  $owner       = 'root',
  $group       = $rbenv::params::group,
  $latest      = false,
  $version     = undef,
  $env         = [],
  $manage_deps = true,
) inherits rbenv::params {

  validate_array($env)

  if $manage_deps {
    include rbenv::deps
  }

  exec { 'git-clone-rbenv':
    command     => "/usr/bin/git clone ${rbenv::repo_path} ${install_dir}",
    creates     => $install_dir,
    cwd         => '/',
    user        => $owner,
    environment => $env,
  }

  file { [
    $install_dir,
    "${install_dir}/plugins",
    "${install_dir}/shims",
    "${install_dir}/versions"
  ]:
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => '0775',
  }

  file { '/etc/profile.d/rbenv.sh':
    ensure  => file,
    content => template('rbenv/rbenv.sh'),
    mode    => '0775'
  }

  # run `git pull` on each run if we want to keep rbenv updated
  if $latest == true {
    exec { 'checkout-rbenv':
      command     => '/usr/bin/git checkout master',
      cwd         => $install_dir,
      user        => $owner,
      environment => $env,
      onlyif      => '/usr/bin/test $(git rev-parse --abbrev-ref HEAD) != "master"',
      require     => File[$install_dir],
    } ->
    exec { 'update-rbenv':
      command     => '/usr/bin/git pull',
      cwd         => $install_dir,
      user        => $owner,
      environment => $env,
      unless      => '/usr/bin/git fetch --quiet; /usr/bin/test $(git rev-parse HEAD) == $(git rev-parse @{u})',
      require     => File[$install_dir],
    }
  } elsif $version {
    exec { 'fetch-rbenv':
      command     => '/usr/bin/git fetch',
      cwd         => $install_dir,
      user        => $owner,
      environment => $env,
      require     => File[$install_dir],
    } ~>
    exec { 'update-rbenv':
      command     => "/usr/bin/git checkout ${version}",
      cwd         => $install_dir,
      user        => $owner,
      environment => $env,
      refreshonly => true,
    }
  }

  Exec['git-clone-rbenv'] -> File[$install_dir]

}
