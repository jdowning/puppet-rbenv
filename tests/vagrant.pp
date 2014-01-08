class { 'rbenv': group => $group }

rbenv::plugin { 'sstephenson/ruby-build': }
rbenv::plugin { 'sstephenson/rbenv-vars': }

# these packages are required for nokogiri
package { ['libxslt1-dev', 'libxml2-dev']: }->
rbenv::build { '2.0.0-p247': global => true }

rbenv::gem { 'backup':
  version      => '3.9.0',
  ruby_version => '2.0.0-p247'
}
