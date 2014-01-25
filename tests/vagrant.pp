class { 'rbenv': group => $group }

rbenv::plugin { 'sstephenson/ruby-build': }
rbenv::plugin { 'sstephenson/rbenv-vars': }

# these packages are required for nokogiri
$nokogiri_deps = $::osfamily ? {
  'RedHat' => ['libxslt-devel', 'libxml2-devel'],
  default  => ['libxslt1-dev', 'libxml2-dev']
}

package { $nokogiri_deps: } ->
rbenv::build { '2.0.0-p247': global => true }

rbenv::gem { 'backup':
  version      => '3.9.0',
  ruby_version => '2.0.0-p247'
}
