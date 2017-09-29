package { 'git': ensure => 'installed' }
-> class { 'rbenv': }
-> rbenv::plugin { 'rbenv/rbenv-vars': }
