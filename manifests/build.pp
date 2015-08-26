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
  $install_dir      = $rbenv::install_dir,
  $owner            = $rbenv::owner,
  $group            = $rbenv::group,
  $global           = false,
  $keep             = false,
  $env              = $rbenv::env,
  $patch            = undef,
  $bundler_version  = '>=0',
) {
  include rbenv

  validate_bool($global)
  validate_bool($keep)

  $environment_for_build = concat(["RBENV_ROOT=${install_dir}"], $env)

  if $patch {
    # Currently only accepts a single file that can be written to the local disk
    if $patch =~ /^((puppet|file):\/\/\/.*)/ {
      # Usually defaults to /var/lib/puppet
      $patch_dir = "${::settings::vardir}/rbenv"
      $patch_file = "${patch_dir}/${title}.patch"

      File {
        owner => 'root',
        group => 'root',
        mode  => '0644',
      }

      file { $patch_dir:
        ensure  => directory,
        recurse => true,
        before  => File[$patch_file],
      }->
      file { $patch_file:
        ensure => file,
        source => $patch,
      }
    }
    else {
      fail('Patch source invalid. Must be puppet:/// or file:///')
    }
  }

  Exec {
    cwd         => $install_dir,
    timeout     => 1800,
    environment => $environment_for_build,
    path        => [
      '/bin/',
      '/sbin/',
      '/usr/bin/',
      '/usr/sbin/',
      "${install_dir}/bin/",
      "${install_dir}/shims/"
    ],
  }

  $install_options = join([ $keep ? { true => ' --keep', default => '' },
                            # patch is a string so we must invert the
                            # logic to use the selector
                            $patch ? { undef => '', false => '', default => ' --patch' } ], '')

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
    # patch file must be read from stdin only if supplied
    command => sprintf("rbenv install ${title}${install_options}%s", $patch ? { undef => '', false => '', default => " < ${patch_file}" }),
    creates => "${install_dir}/versions/${title}",
  }~>
  exec { "rbenv-ownit-${title}":
    command     => "chown -R ${owner}:${group} \
                    ${install_dir}/versions/${title} && \
                    chmod -R g+w ${install_dir}/versions/${title}",
    user        => 'root',
    refreshonly => true,
  }

  # Install Bundler with no docs
  # The 2.5.x version of rdoc (used in Ruby 1.8.x and 1.9.x) causes
  # this error if docs are included during puppet run:
  #   ERROR:  While executing gem ... (TypeError)
  #     can't convert nil into String
  # Updating rdoc before installing gems via rbenv::gem also fixes this issue
  rbenv::gem { "bundler-${title}":
    gem          => 'bundler',
    ruby_version => $title,
    skip_docs    => true,
    version      => $bundler_version,
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
