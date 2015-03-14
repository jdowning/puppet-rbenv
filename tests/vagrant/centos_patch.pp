class { 'rbenv': group => $group }

rbenv::plugin { 'sstephenson/ruby-build': }

# CentOS 6.6 (Final) does not have patch installed by default
package { 'patch':
  ensure => 'installed',
}->
rbenv::build { '1.9.2-p180':
  global => true,
  patch => 'file:///tmp/puppet-modules/rbenv/tests/patches/1.9.2-p180_centos.patch',
}
