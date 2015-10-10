# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = 'puppet-rbenv'
  config.vm.synced_folder "modules", "/tmp/puppet-modules", type: "rsync", rsync__exclude: ".git/"
  config.vm.synced_folder ".", "/tmp/puppet-modules/rbenv", type: "rsync", rsync__exclude: [".git/","spec/"]

  config.vm.provision :puppet do |puppet|
    puppet.environment_path = "tests"
    puppet.environment = "vagrant"
    puppet.options        = ["--modulepath", "/tmp/puppet-modules"]
  end

  config.vm.define "centos" do |centos|
    centos.vm.box = 'puppetlabs/centos-7.0-64-puppet'
  end

  config.vm.define "ubuntu", primary: true do |ubuntu|
    ubuntu.vm.box = 'puppetlabs/ubuntu-14.04-64-puppet'
  end
end
