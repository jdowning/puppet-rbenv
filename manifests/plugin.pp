# == Define: rbenv::plugin
#
# === Variables
#
# [$install_dir]
#   This is set when you declare the rbenv class. There is no
#   need to overrite it when calling the rbenv::gem define.
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
# === Requires
#
# puppetlabs/git
#
# === Examples
#
# rbenv::plugin { 'jamis/rbenv-gemset': }
#
# === Authors
#
# Justin Downing <justin@downing.us>
#
define rbenv::plugin(
  $install_dir = $rbenv::install_dir,
  $owner       = $rbenv::owner,
  $group       = $rbenv::group,
) {
  require rbenv

  $plugin = split($name, '/') # divide plugin name into array

  exec { "install-${name}":
    command => "/usr/bin/git clone https://github.com/${plugin[0]}/${plugin[1]}",
    cwd     => "${install_dir}/plugins",
    path    => [ '/usr/bin' ],
    onlyif  => "test -d ${install_dir}/plugins",
    unless  => "test -d ${install_dir}/plugins/${plugin[1]}",
  }~>
  exec { "rbenv-permissions-${name}":
    command     => "chown -R ${owner}:${group} ${install_dir} && \
                    chmod -R g+w ${install_dir}",
    path        => [ '/bin' ],
    refreshonly => true,
  }

}
