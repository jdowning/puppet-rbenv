## DEFINE
define rbenv::build ($global=false) {
  include rbenv::params

  file { "/tmp/ruby-build-${title}":
    content => template('rbenv/ruby-build.sh.erb'),
    mode    => '0755',
  }

  exec { "/tmp/ruby-build-${title}":
    require => [ Package['build-essential'], Rbenv::Plugin['sstephenson/ruby-build'] ],
    timeout => 1800,
    unless  => "/usr/bin/test -d /usr/local/rbenv/versions/${title}",
  }->
  exec { 'build-bootstrap':
    command => 'gem install bundler --no-ri --no-rdoc',
    path    => "${rbenv::params::install_dir}/versions/${title}/bin",
    unless  => "/bin/ls ${rbenv::params::install_dir}/versions/${title}/bin/bundle 2>/dev/null",
  }
}
