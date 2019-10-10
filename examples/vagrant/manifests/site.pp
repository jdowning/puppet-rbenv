class { 'rbenv': group => $group }

rbenv::plugin { 'rbenv/ruby-build': }
rbenv::plugin { 'rbenv/rbenv-vars': }
rbenv::build { '2.4.3': global => true }

rbenv::gem { 'rack':
  ruby_version => '2.4.3',
  skip_docs    => true,
}

rbenv::gem { 'json':
  version      => '2.2.0',
  ruby_version => '2.4.3',
  skip_docs    => true,
}
