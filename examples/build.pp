class { 'rbenv': }
-> rbenv::plugin { 'rbenv/ruby-build': }
-> rbenv::build { '2.0.0-p247':
  rubygems_version => '3.2.1',
  bundler_version => '1.17.3',
  global => true,
}
