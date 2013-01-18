## DEFINE
define rbenv::build ($global=false) {
  include rbenv::params

  file { "/tmp/ruby-build-${title}":
    content => template('rbenv/ruby-build.sh.erb'),
    mode    => '0755',
  }

  exec { "/tmp/ruby-build-${title}":
    require => [ Package['build-essential'], Rbenv::Plugin['sstephenson/ruby-build'] ],
    timeout => 600,
    unless  => "${rbenv::params::install_dir}/bin/rbenv versions | /bin/grep ${title}",
    notify  => Exec['build-bootstrap'],
  }

  exec { 'build-bootstrap':
    command     => 'gem install bundler --no-ri --no-rdoc',
    path        => "${rbenv::params::install_dir}/versions/${title}/bin",
    refreshonly => true,
  }
}
