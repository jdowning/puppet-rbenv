## DEFINE
define rbenv::plugin {
  require rbenv
  include rbenv::params

  $plugin = split($title, '/')

  exec { "install-${name}":
    command => "git clone https://github.com/${plugin[0]}/${plugin[1]}",
    cwd     => "${rbenv::params::install_dir}/plugins",
    path    => [ '/usr/bin' ],
    onlyif  => "test -d ${rbenv::params::install_dir}/plugins",
    unless  => "test -d ${rbenv::params::install_dir}/plugins/${plugin[1]}",
  }~>
  exec { "rbenv-permissions-${name}":
    command     => "chown -R ${rbenv::params::owner}:${rbenv::params::group} ${rbenv::params::install_dir} && \
                    chmod -R g+w ${rbenv::params::install_dir}",
    path        => [ '/bin' ],
    refreshonly => true,
  }

}
