class { 'git': }
class { 'rbenv': }
rbenv::plugin { 'sstephenson/rbenv-vars':
  require => Class['git'],
}
