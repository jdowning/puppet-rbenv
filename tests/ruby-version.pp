class { 'rbenv': }

rbenv::plugin { 'sstephenson/ruby-build': }->
rbenv::build { '1.9.3-p362': global => true }
