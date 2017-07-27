# === Define: rbenv::download
#
# This class was made to be able to use the non-official rbenv plugin:
# rvm-download (https://github.com/garnieretienne/rvm-download).
#
# With that plugin we can download directly some ruby versions precompiled,
# so we don't have to compile the ruby version on all of our instances where
# we are installing an specific ruby version.
#
# To see which versions are available you can enter to an instance and run:
#  * rbenv download --list
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
# [$env]
#   This is used to set environment variables when downloading ruby.
#   Default: []
#   This variable is optional.
#
# === Examples
#
# profile::rbenv::download { '2.0.0-p247': global => true }
#
define rbenv::download (
  $install_dir = $rbenv::install_dir,
  $owner  = $rbenv::owner,
  $group  = $rbenv::group,
  $global = false,
  $env    = []
){
  include rbenv

  validate_bool($global)
  $environment_for_download = concat(["RBENV_ROOT=${install_dir}"], $env)

  Exec {
    cwd     => $install_dir,
    path    => [
      '/bin/',
      '/sbin/',
      '/usr/bin/',
      '/usr/sbin/',
      "${install_dir}/bin/",
      "${install_dir}/shims/"
    ],
    timeout => 1800,
  }

  exec { "own-plugins-${title}":
    command => "chown -R ${owner}:${group} ${install_dir}/plugins",
    user    => 'root',
    unless  => "test -d ${install_dir}/versions/${title}",
    require => Class['rbenv'],
  }->
  exec { "git-pull-rvmdownload-${title}":
    command => 'git reset --hard HEAD && git pull',
    cwd     => "${install_dir}/plugins/rvm-download",
    user    => 'root',
    unless  => "test -d ${install_dir}/versions/${title}",
    require => Rbenv::Plugin['garnieretienne/rvm-download'],
  }->
  exec { "rbenv-download-${title}":
    command     => "rbenv download ${title}",
    environment => $environment_for_download,
    creates     => "${install_dir}/versions/${title}",
  }~>
  exec { "rbenv-ownit-${title}":
    command     => "chown -R ${owner}:${group} \
                    ${install_dir}/versions/${title} && \
                    chmod -R g+w ${install_dir}/versions/${title}",
    user        => 'root',
    refreshonly => true,
  }

  if $global {
    exec { "rbenv-global-${title}":
      command     => "rbenv global ${title}",
      environment => ["RBENV_ROOT=${install_dir}"],
      require     => Exec["rbenv-download-${title}"],
    }
  }
}

