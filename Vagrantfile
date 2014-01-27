# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = 'puppet-rbenv'
  config.vm.synced_folder ".", "/tmp/rbenv"

  config.vm.define "centos" do |centos|
    centos.vm.box     = 'centos65'
    centos.vm.box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-puppet.box'
    config.vm.provision :shell, :inline => "sudo yum install -y openssl"
    centos.vm.provision :puppet do |puppet|
      puppet.manifests_path = "tests/vagrant"
      puppet.manifest_file  = "centos.pp"
      puppet.options        = ["--modulepath", "/tmp"]
    end
  end

  config.vm.define "ubuntu", primary: true do |ubuntu|
    ubuntu.vm.box     = 'ubuntu64'
    ubuntu.vm.box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210.box'
    ubuntu.vm.provision :shell, :inline => 'aptitude update'
    ubuntu.vm.provision :puppet do |puppet|
      puppet.manifests_path = "tests/vagrant"
      puppet.manifest_file  = "ubuntu.pp"
      puppet.options        = ["--modulepath", "/tmp"]
    end
  end

end
