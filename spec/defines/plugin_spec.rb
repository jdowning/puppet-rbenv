require 'spec_helper'

describe 'rbenv::plugin' do
  describe 'install ruby-build' do
    let(:title) { 'rbenv/ruby-build' }
    let(:facts) { { :osfamily => 'Debian' } }
    let(:params) do
      {
        :install_dir => '/usr/local/rbenv',
        :latest      => true,
        :env         => ['RUBY_CFLAGS=-O3 -march=native'],
      }
    end

    it { should contain_class('rbenv') }
    it { should contain_exec("install-rbenv/ruby-build") }
    it { should contain_exec("rbenv-permissions-rbenv/ruby-build") }
    it { should contain_exec("update-rbenv/ruby-build") }
  end
end
