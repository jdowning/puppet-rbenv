# == Define: rbenv::build
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
# === Requires
#
# puppetlabs/git
#
# === Examples
#
# rbenv::build { '2.0.0-p195': global => true }
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
) {

  Exec {
    cwd     => $install_dir,
    path    => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/', "${install_dir}/bin/" ],
    timeout => 1800,
  }

  exec { "own-plugins-${title}":
    command => "chown -R ${owner}:${group} ${install_dir}/plugins",
    user    => 'root',
    unless  => "/usr/bin/test -d ${install_dir}/versions/${title}",
  }->
  exec { "git-pull-rubybuild-${title}":
    command => '/usr/bin/git reset --hard HEAD && /usr/bin/git pull',
    cwd     => "${install_dir}/plugins/ruby-build",
    user    => 'root',
    unless  => "/usr/bin/test -d ${install_dir}/versions/${title}",
    require => Class['git'],
  }->
  exec { "rbenv-install-${title}":
    command     => "${install_dir}/bin/rbenv install ${title}",
    environment => ['CFLAGS=-O3 -march=native'],
    creates     => "${install_dir}/versions/${title}",
    require     => Package['build-essential'],
  }~>
  exec { "bundler-install-${title}":
    command     => "${install_dir}/shims/gem install bundler",
    environment => ["RBENV_VERSION=${title}"],
    refreshonly => true,
  }~>
  exec { "rbenv-rehash-${title}":
    command     => 'rbenv rehash',
    refreshonly => true,
  }~>
  exec { "rbenv-ownit-${title}":
    command     => "chown -R ${owner}:${group} ${install_dir}/versions/${title} && chmod -R g+w ${install_dir}/versions/${title}",
    user        => 'root',
    refreshonly => true,
  }

  if $global == true {
    exec { "rbenv-global${title}":
      command     => "rbenv global ${title}",
      require     => Exec["rbenv-install-${title}"],
      subscribe   => Exec["rbenv-ownit-${title}"],
      refreshonly => true,
    }
  }

}
