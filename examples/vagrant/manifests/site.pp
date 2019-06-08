class { 'rbenv': group => $group }

rbenv::plugin { 'rbenv/ruby-build': }
rbenv::plugin { 'rbenv/rbenv-vars': }
rbenv::build { '2.1.7': global => true }

rbenv::gem { 'rack':
  ruby_version => '2.1.7',
  skip_docs    => true,
}

rbenv::gem { 'backup':
  version      => '4.0.2',
  ruby_version => '2.1.7',
  skip_docs    => true,
}
