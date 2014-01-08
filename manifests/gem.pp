# == Define: rbenv::gem
#
# Calling this define will install a ruby gem for a specific ruby version
#
# === Variable
#
# [$install_dir]
#   This is set when you declare the rbenv class. There is no
#   need to overrite it when calling the rbenv::gem define.
#   Default: $rbenv::install_dir
#   This variable is required.
#
# [$gem]
#   The name of the gem to be installed. Useful if you are going
#   to install the same gem under multiple ruby versions.
#   Default: $title
#   This variable is optional.
#
# [$version]
#   The version of the gem to be installed.
#   Default: '>= 0'
#   This variable is optional.
#
# [$ruby_version]
#   The ruby version under which the gem will be installed.
#   Default: undefined
#   This variable is required.
#
# === Examples
#
# rbenv::gem { 'thor': ruby_version => '2.0.0-p247' }
#
# === Authors
#
# Justin Downing <justin@downing.us>
#
define rbenv::gem(
  $install_dir  = $rbenv::install_dir,
  $gem          = $title,
  $version      = '>=0',
  $ruby_version = undef,
) {
  include rbenv

  if $ruby_version == undef {
    fail('You must declare a ruby_version for rbenv::gem')
  }

  exec { "gem-install-${gem}-${ruby_version}":
    command => "gem install ${gem} --version '${version}'",
    unless  => "gem list ${gem} --installed --version '${version}'",
    path    => ["${install_dir}/versions/${ruby_version}/bin/",'/usr/bin','/usr/sbin','/bin','/sbin'],
  }~>
  exec { "rbenv-rehash-${gem}-${ruby_version}":
    command     => "${install_dir}/bin/rbenv rehash",
    refreshonly => true,
  }~>
  exec { "rbenv-permissions-${gem}-${ruby_version}":
    command     => "/bin/chown -R ${rbenv::owner}:${rbenv::group} ${install_dir}/versions/${ruby_version}/lib/ruby/gems && /bin/chmod -R g+w ${install_dir}/versions/${ruby_version}/lib/ruby/gems",
    refreshonly => true,
  }

  Exec { require => Exec["rbenv-install-${ruby_version}"] }
}
