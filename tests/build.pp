class { 'rbenv': }->
rbenv::plugin { 'rbenv/ruby-build': }->
rbenv::build { '2.0.0-p247': global => true }
