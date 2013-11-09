require 'spec_helper'

describe 'rbenv::plugin' do
  describe 'install ruby-build' do
    let(:title) { 'sstephenson/ruby-build' }
    let(:facts) { { :osfamily => 'Debian' } }
    let(:params) do
      {
        :install_dir => '/usr/local/rbenv',
        :owner => 'root',
        :group => 'adm',
      }
    end

    it { should include_class('rbenv') }

    it { should contain_exec("install-sstephenson/ruby-build") }
    #it { should contain_exec("install-ruby-build").with(
    #  {
    #    'command' => "/usr/bin/git clone git://github.com/sstephenson/ruby-build.git",
    #    'cwd' => "/usr/local/rbenv/plugins",
    #    'onlyif' => "/usr/bin/test -d /usr/local/rbenv/plugins",
    #    'unless' => "/usr/bin/test -d /usr/local/rbenv/plugins/ruby-build",
    #  }
    #)}

    it { should contain_exec("rbenv-permissions-sstephenson/ruby-build") }
    #it { should contain_exec('rbenv-permissions-ruby-build').with(
    #  {
    #    'command' => "chown -R root:adm /usr/local/rbenv && chmod -R g+w /usr/local/rbenv",
    #    'refreshonly' => true,
    #  }
    #)}

  end

end
