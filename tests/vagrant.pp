class { 'rbenv': group => $group }

rbenv::plugin { 'sstephenson/ruby-build': }
rbenv::plugin { 'sstephenson/rbenv-vars': }

rbenv::build { '2.0.0-p247': global => true }

rbenv::gem { 'thor':
  version      => '0.18.1',
  ruby_version => '2.0.0-p247'
}
