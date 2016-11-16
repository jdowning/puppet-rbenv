package { 'git': ensure => 'installed' }->
class { 'rbenv': }->
rbenv::plugin { 'rbenv/ruby-build': }
