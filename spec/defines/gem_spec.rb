require 'spec_helper'

describe 'rbenv::gem' do
  describe 'install bundler' do
    let(:title) { 'bundler' }
    let(:params) do
      {
        :install_dir  => '/usr/local/rbenv',
        :version      => '1.3.5',
        :ruby_version => '2.0.0-p195'
      }
    end

    it { should include_class('rbenv') }

    it { should contain_exec("gem-install-bundler") }
    #it { should include_exec("gem-install-bundler").with(
    #  {
    #    'command' => "gem install bundler --version '1.3.5'",
    #    'onlyif'  => "/usr/bin/test -d /usr/local/rbenv/versions/2.0.0-p195",
    #    'unless'  => "gem list bundler --installed --version '1.3.5'",
    #    'path'    => "/usr/local/rbenv/versions/2.0.0-p195/bin/",
    #  }
    #)}

    it { should contain_exec("rbenv-rehash-bundler") }
    #it { should include_exec("rbenv-rehash-bundler").with(
    #  {
    #    'command'     => "/usr/local/rbenv/bin/rbenv rehash",
    #    'refreshonly' => true,
    #  }
    #)}

  end
end
