# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = 'puppet-rbenv'
  config.vm.synced_folder "modules", "/tmp/puppet-modules", type: "rsync", rsync__exclude: ".git/"
  config.vm.synced_folder ".", "/tmp/puppet-modules/rbenv", type: "rsync", rsync__exclude: ".git/"

  config.vm.define "centos" do |centos|
    centos.vm.box     = 'puppetlabs/centos-7.0-64-puppet'
    #config.vm.provision :shell, :inline => "sudo yum install -y openssl"
    centos.vm.provision :puppet do |puppet|
      puppet.manifests_path = "tests/vagrant"
      puppet.manifest_file  = "centos.pp"
      puppet.options        = ["--modulepath", "/tmp/puppet-modules"]
    end
  end

  config.vm.define "debian", primary: true do |debian|
    debian.vm.box     = 'puppetlabs/debian-7.6-64-puppet'
    debian.vm.provision :shell, :inline => 'apt-get update'
    debian.vm.provision :puppet do |puppet|
      puppet.manifests_path = "tests/vagrant"
      puppet.manifest_file  = "ubuntu.pp"
      puppet.options        = ["--modulepath", "/tmp/puppet-modules"]
    end
  end

  config.vm.define "ubuntu", primary: true do |ubuntu|
    ubuntu.vm.box     = 'puppetlabs/ubuntu-14.04-64-puppet'
    ubuntu.vm.provision :shell, :inline => 'aptitude update'
    ubuntu.vm.provision :puppet do |puppet|
      puppet.manifests_path = "tests/vagrant"
      puppet.manifest_file  = "ubuntu.pp"
      puppet.options        = ["--modulepath", "/tmp/puppet-modules"]
    end
  end

end
