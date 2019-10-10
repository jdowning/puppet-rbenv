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
# [$skip_docs]
#   Skips the installation of ri and rdoc docs.
#   Default: false
#   This variable is optional.

# [$timeout]
#   Seconds that a gem has to finish installing. Set to 0 for unlimited.
#   Default: 300
#   This variable is optional.
#
# [$env]
#   This is used to set environment variables when installing a gem.
#   Default: []
#   This variable is optional.
#
# [$source]
#   Source to be passed ot the gem command
#   Default: "https://rubygems.org/"
#   This variable is optional.
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
  $skip_docs    = false,
  $timeout      = 300,
  $env          = $rbenv::env,
  $source       = 'https://rubygems.org/'
) {
  include rbenv

  if $ruby_version == undef {
    fail('You must declare a ruby_version for rbenv::gem')
  }

  if ($skip_docs) {
    $docs = '--no-document'
  } else {
    $docs = ''
  }

  $environment_for_install = concat(["RBENV_ROOT=${install_dir}"], $env)
  $version_for_exec_name = regsubst($version, '[^0-9]+', '_', 'EG')

  exec { "ruby-${ruby_version}-gem-install-${gem}-${version_for_exec_name}":
    command => "gem install ${gem} --version '${version}' ${docs} --source '${source}'",
    unless  => "gem list ${gem} --installed --version '${version}'",
    path    => [
      "${install_dir}/versions/${ruby_version}/bin/",
      '/usr/bin',
      '/usr/sbin',
      '/bin',
      '/sbin'
    ],
    timeout => $timeout
  }
  ~> exec { "ruby-${ruby_version}-rbenv-rehash-${gem}-${version_for_exec_name}":
    command     => "${install_dir}/bin/rbenv rehash",
    refreshonly => true,
  }
  ~> exec { "ruby-${ruby_version}-rbenv-permissions-${gem}-${version_for_exec_name}":
    command     => "/bin/chown -R ${rbenv::owner}:${rbenv::group} \
                  ${install_dir}/versions/${ruby_version}/lib/ruby/gems && \
                  /bin/chmod -R g+w \
                  ${install_dir}/versions/${ruby_version}/lib/ruby/gems",
    refreshonly => true,
  }

  Exec {
    environment => $environment_for_install,
    require => Exec["rbenv-install-${ruby_version}"]
  }
}
