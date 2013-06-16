class { 'git': }
package { 'build-essential': }
class { 'rbenv': }
rbenv::plugin { 'sstephenson/ruby-build': }
rbenv::build { '1.9.3-p385': }
rbenv::gem { 'bundler': ruby_version => '1.9.3-p385' }
