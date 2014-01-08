# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = 'puppet-rbenv'
  config.vm.synced_folder ".", "/tmp/rbenv"

  config.vm.define "centos" do |centos|
    centos.vm.box     = 'centos64'
    centos.vm.box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box'
    centos.vm.provision :puppet do |puppet|
      puppet.manifests_path = "tests"
      puppet.manifest_file  = "vagrant.pp"
      puppet.options        = ["--modulepath", "/tmp"]
    end
  end

  config.vm.define "suse" do |suse|
    suse.vm.box     = 'suse64'
    suse.vm.box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/sles-11sp1-x64-vbox4210.box'
    suse.vm.provision :shell, :inline => "sudo zypper mr --disable 1"
    suse.vm.provision :puppet do |puppet|
      puppet.manifests_path = "tests"
      puppet.manifest_file  = "vagrant.pp"
      puppet.options        = ["--modulepath", "/tmp"]
    end
  end

  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.box     = 'ubuntu64'
    ubuntu.vm.box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210.box'
    ubuntu.vm.provision :shell, :inline => 'aptitude update'
    ubuntu.vm.provision :puppet do |puppet|
      puppet.manifests_path = "tests"
      puppet.manifest_file  = "vagrant.pp"
      puppet.options        = ["--modulepath", "/tmp"]
    end
  end

end
