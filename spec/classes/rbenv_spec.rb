require 'spec_helper'

describe 'rbenv', :type => 'class' do
  let(:facts) { { :osfamily => 'Debian' } }
  let(:params) do
    {
      :install_dir => '/usr/local/rbenv',
      :latest      => true,
    }
  end

  it { should contain_exec('git-clone-rbenv').with(
    {
      'command' => '/usr/bin/git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv',
      'creates' => '/usr/local/rbenv',
    }
  )}

  [ 'plugins', 'shims', 'versions' ].each do |dir|
    describe "creates #{dir}" do
      it { should contain_file("/usr/local/rbenv/#{dir}").with({
          'ensure'  => 'directory',
          'owner'   => 'root',
          'group'   => 'adm',
          'mode'    => '0775',
        })
      }
    end
  end

  it { should contain_file('/etc/profile.d/rbenv.sh').with(
    {
      'ensure'  => 'file',
      'mode'    => '0775',
    }
  )}

  it { should contain_exec("update-rbenv") }
end
