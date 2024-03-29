# == Define: rbenv::plugin
#
# === Variables
#
# @param install_dir
#   This is set when you declare the rbenv class. There is no
#   need to overrite it when calling the rbenv::gem define.
#   Default: $rbenv::install_dir
#   This variable is required.
#
# @param repo_path
#   This is the git repo used to install the plugin.
#   Default: https://github.com/${name}.git
#   This variable is required.
#
# @param latest
#   This defines whether the plugin is kept up-to-date.
#   Defaults: false
#   This vaiable is optional.
#
# @param env
#   This is used to set environment variables when installing plugins.
#   Default: []
#   This variable is optional.
#
# === Requires
#
# You will need to install the git package on the host system.
#
# === Examples
#
# rbenv::plugin { 'jamis/rbenv-gemset': }
#
# === Authors
#
# Justin Downing <justin@downing.us>
#
define rbenv::plugin (
  Stdlib::Absolutepath $install_dir = $rbenv::install_dir,
  Stdlib::HTTPUrl $repo_path        = "https://github.com/${name}.git",
  Boolean $latest                   = false,
  Array $env                        = $rbenv::env,
) {
  include rbenv

  $plugin = split($name, '/') # divide plugin name into array

  Exec { environment => $env }

  exec { "install-${name}":
    command => "/usr/bin/git clone ${repo_path}",
    cwd     => "${install_dir}/plugins",
    onlyif  => "/usr/bin/test -d ${install_dir}/plugins",
    unless  => "/usr/bin/test -d ${install_dir}/plugins/${plugin[1]}",
  }
  ~> exec { "rbenv-permissions-${name}":
    command     => "/bin/chown -R ${rbenv::owner}:${rbenv::group} \
                    ${install_dir} && \
                    /bin/chmod -R g+w ${install_dir}",
    refreshonly => true,
  }

  # run `git pull` on each run if we want to keep the plugin updated
  if $latest == true {
    exec { "update-${name}":
      command => '/usr/bin/git pull',
      cwd     => "${install_dir}/plugins/${plugin[1]}",
      user    => $rbenv::owner,
      onlyif  => "/usr/bin/test -d ${install_dir}/plugins/${plugin[1]}",
      unless  => '/usr/bin/git fetch --quiet; /usr/bin/test $(git rev-parse HEAD) == $(git rev-parse @{u})',
    }
  }
}
