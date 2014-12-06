# == Define: rbenv::build
#
# Calling this define will install Ruby in your default rbenv
# installs directory. Additionally, it can define the installed
# ruby as the global interpretter. It will install the bundler gem.
#
# === Variables
#
# [$install_dir]
#   This is set when you declare the rbenv class. There is no
#   need to overrite it when calling the rbenv::build define.
#   Default: $rbenv::install_dir
#   This variable is required.
#
# [$owner]
#   This is set when you declare the rbenv class. There is no
#   need to overrite it when calling the rbenv::build define.
#   Default: $rbenv::owner
#   This variable is required.
#
# [$group]
#   This is set when you declare the rbenv class. There is no
#   need to overrite it when calling the rbenv::build define.
#   Default: $rbenv::group
#   This variable is required.
#
# [$global]
#   This is used to set the ruby to be the global interpreter.
#   Default: false
#   This variable is optional.
#
# [%keep]
#   This is used to keep the source code of a compiled ruby.
#   Default: false
#   This variable is optional.
#
# [$env]
#   This is used to set environment variables when compiling ruby.
#   Default: []
#   This variable is optional.
#
# === Examples
#
# rbenv::build { '2.0.0-p247': global => true }
#
# === Authors
#
# Justin Downing <justin@downing.us>
#
define rbenv::build (
  $install_dir = $rbenv::install_dir,
  $owner       = $rbenv::owner,
  $group       = $rbenv::group,
  $global      = false,
  $keep        = false,
  $env         = [],
) {
  include rbenv

  validate_bool($global)
  validate_bool($keep)
  validate_array($env)
  $environment_for_build = concat(["RBENV_ROOT=${install_dir}"], $env)

  Exec {
    cwd     => $install_dir,
    path    => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/', "${install_dir}/bin/", "${install_dir}/shims/" ],
    timeout => 1800,
  }

  $install_options = $keep ? {
    true    => ' --keep',
    default => '',
  }

  exec { "own-plugins-${title}":
    command => "chown -R ${owner}:${group} ${install_dir}/plugins",
    user    => 'root',
    unless  => "test -d ${install_dir}/versions/${title}",
    require => Class['rbenv'],
  }->
  exec { "git-pull-rubybuild-${title}":
    command => 'git reset --hard HEAD && git pull',
    cwd     => "${install_dir}/plugins/ruby-build",
    user    => 'root',
    unless  => "test -d ${install_dir}/versions/${title}",
    require => Rbenv::Plugin['sstephenson/ruby-build'],
  }->
  exec { "rbenv-install-${title}":
    command     => "rbenv install ${title}${install_options}",
    environment => $environment_for_build,
    creates     => "${install_dir}/versions/${title}",
  }~>
  exec { "rbenv-ownit-${title}":
    command     => "chown -R ${owner}:${group} ${install_dir}/versions/${title} && chmod -R g+w ${install_dir}/versions/${title}",
    user        => 'root',
    refreshonly => true,
  }

  # Install Bundler
  rbenv::gem { "bundler-${title}":
    gem          => 'bundler',
    ruby_version => $title,
  }

  if $global == true {
    exec { "rbenv-global-${title}":
      command     => "rbenv global ${title}",
      environment => ["RBENV_ROOT=${install_dir}"],
      require     => Exec["rbenv-install-${title}"],
      subscribe   => Exec["rbenv-ownit-${title}"],
      refreshonly => true,
    }
  }

}
