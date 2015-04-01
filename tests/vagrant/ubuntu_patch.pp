class { 'rbenv': group => $group }

rbenv::plugin { 'sstephenson/ruby-build': }

package { ['libxslt1-dev', 'libxml2-dev', 'libjemalloc1']: }->
file { '/usr/lib/libjemalloc.so':
  ensure => link,
  target => '/usr/lib/libjemalloc.so.1',
}->
rbenv::build { '1.9.2-p180':
  global => true,
  patch  => 'file:///tmp/puppet-modules/rbenv/tests/patches/1.9.2-p180_ubuntu.patch',
}
