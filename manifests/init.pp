# == Class: rbenv
#
# Full description of class rbenv here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { rbenv:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Justin Downing <justin@downing.us>
#
# === Copyright
#
# Copyright 2013 Justin Downing
#
class rbenv {

  require git

  include rbenv::params

  exec { 'git-clone-rbenv':
    command   => "/usr/bin/git clone \
                  ${rbenv::params::repo_path} \
                  ${rbenv::params::install_dir}",
    creates   => $rbenv::params::install_dir
  }

  file { [
    $rbenv::params::install_dir,
    "${rbenv::params::install_dir}/plugins",
    "${rbenv::params::install_dir}/shims",
    "${rbenv::params::install_dir}/versions"
  ]:
    ensure    => directory,
    owner     => 'root',
    group     => 'admin',
    mode      => '0775',
  }

  file { '/etc/profile.d/rbenv.sh':
    ensure    => file,
    content   => template('rbenv/rbenv.sh'),
    mode      => '0775'
  }

  Exec['git-clone-rbenv'] -> File['/usr/local/rbenv']

}
