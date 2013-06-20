class { 'git': }
class { 'rbenv': }

rbenv::plugin { 'sstephenson/ruby-build':
  require => Class['git'],
}
