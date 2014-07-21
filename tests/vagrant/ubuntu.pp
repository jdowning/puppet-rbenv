class { 'rbenv': group => $group }

rbenv::plugin { 'sstephenson/ruby-build': }
rbenv::plugin { 'sstephenson/rbenv-vars': }

package { ['libxslt1-dev', 'libxml2-dev', 'libjemalloc1']: }->
file { '/usr/lib/libjemalloc.so':
  ensure => link,
  target => '/usr/lib/libjemalloc.so.1',
}->
rbenv::build { '2.1.2':
  global => true,
  env    => ['RUBY_CFLAGS=-O3 -march=native', 'LIBS=-ljemalloc', 'MAKE_OPTS=-j4', 'MAKE_INSTALL_OPTS=-j4'],
}

rbenv::gem { 'backup':
  version      => '4.0.2',
  ruby_version => '2.1.2',
  skip_docs    => true,
}
