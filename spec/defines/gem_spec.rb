require 'spec_helper'

describe 'rbenv::gem' do
  describe 'install bundler' do
    let(:title) { 'bundler' }
    let(:facts) { { :osfamily => 'Debian' } }
    let(:params) do
      {
        :install_dir  => '/usr/local/rbenv',
        :version      => '1.3.5',
        :ruby_version => '2.0.0-p247',
        :env          => ['RUBY_CFLAGS=-O3 -march=native'],
      }
    end

    it { should contain_class('rbenv') }
    it { should contain_exec("ruby-2.0.0-p247-gem-install-bundler-1_3_5") }
    it { should contain_exec("ruby-2.0.0-p247-rbenv-rehash-bundler-1_3_5") }
    it { should contain_exec("ruby-2.0.0-p247-rbenv-permissions-bundler-1_3_5") }
  end
end
