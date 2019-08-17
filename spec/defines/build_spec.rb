require 'spec_helper'

describe 'rbenv::build' do
  describe 'install 2.0.0-p247' do
    let(:title) { '2.0.0-p247' }
    let(:facts) { { osfamily: 'Debian', vardir: '/var/lib/puppet' } }
    let(:pre_condition) { 'rbenv::plugin { "rbenv/ruby-build": install_dir => "/usr/local/rbenv", env => ["RUBY_CFLAGS=-O3 -march=native"] }' }
    let(:params) do
      {
        install_dir: '/usr/local/rbenv',
        owner: 'root',
        group: 'adm',
        global: false,
        env: ['RUBY_CFLAGS=-O3 -march=native'],
        bundler_version: '>1.9',
      }
    end

    it { is_expected.to contain_class('rbenv') }

    it { is_expected.to contain_exec('own-plugins-2.0.0-p247') }
    it { is_expected.to contain_exec('git-pull-rubybuild-2.0.0-p247') }
    it { is_expected.to contain_exec('rbenv-install-2.0.0-p247') }
    it { is_expected.to contain_exec('rbenv-ownit-2.0.0-p247') }
    # Included to ensure bundler docs are skipped to avoid outdated rdoc error
    it { is_expected.to contain_rbenv__gem('bundler-2.0.0-p247').with('skip_docs' => true, 'version' => '>1.9') }

    context 'with global => true' do
      let(:params) do
        {
          install_dir: '/usr/local/rbenv',
          owner: 'root',
          group: 'adm',
          global: true,
          env: ['RUBY_CFLAGS=-O3 -march=native'],
        }
      end

      it { is_expected.to contain_exec('rbenv-global-2.0.0-p247') }
    end

    # Regex because we use ::settings::vardir which is a randomly
    # named tmp directory in the tests
    patch_cmd_regex = %r{rbenv install 2\.0\.0-p247 --patch < /(tmp|var/folders)/.+/rbenv/2\.0\.0-p247\.patch}

    context 'with patch => file:///path/to/patch.patch' do
      let(:params) do
        {
          install_dir: '/usr/local/rbenv',
          owner: 'root',
          group: 'adm',
          global: false,
          env: ['RUBY_CFLAGS=-O3 -march=native'],
          patch: 'file:///path/to/patch.patch',
        }
      end

      it { is_expected.to contain_exec('rbenv-install-2.0.0-p247').with_command(patch_cmd_regex) }
    end

    context 'with patch => puppet:///modules/rbenv/patch.patch' do
      let(:params) do
        {
          install_dir: '/usr/local/rbenv',
          owner: 'root',
          group: 'adm',
          global: false,
          env: ['RUBY_CFLAGS=-O3 -march=native'],
          patch: 'puppet:///modules/rbenv/patch.patch',
        }
      end

      it { is_expected.to contain_exec('rbenv-install-2.0.0-p247').with_command(patch_cmd_regex) }
    end

    context 'with invalid patch => http://example.com/patch.patch' do
      let(:params) do
        {
          install_dir: '/usr/local/rbenv',
          owner: 'root',
          group: 'adm',
          global: false,
          env: ['RUBY_CFLAGS=-O3 -march=native'],
          patch: 'http://example.com/patch.patch',
        }
      end

      it do
        expect {
          is_expected.to contain_exec('rbenv-install-2.0.0-p247').with_command(patch_cmd_regex)
        }.to raise_error(Puppet::Error, %r{Patch source invalid})
      end
    end
  end
end
