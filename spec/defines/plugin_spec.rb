require 'spec_helper'

describe 'rbenv::plugin' do
  describe 'install ruby-build' do
    let(:title) { 'rbenv/ruby-build' }
    let(:facts) do
      {
        'os' => {
          'family' => 'Debian',
          'distro' => {
            'codename' => 'xenial'
          }
        }
      }
    end
    let(:params) do
      {
        install_dir: '/usr/local/rbenv',
        latest: true,
        env: ['RUBY_CFLAGS=-O3 -march=native'],
      }
    end

    it { is_expected.to contain_class('rbenv') }
    it { is_expected.to contain_exec('install-rbenv/ruby-build') }
    it { is_expected.to contain_exec('rbenv-permissions-rbenv/ruby-build') }
    it { is_expected.to contain_exec('update-rbenv/ruby-build') }
  end
end
