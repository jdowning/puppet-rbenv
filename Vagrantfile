# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box     = 'precise64'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'
  config.vm.host_name = 'puppet-rbenv'

  config.vm.provision :shell, :inline => "sudo aptitude install -y build-essential git"
  config.vm.provision :puppet do |puppet|
	puppet.manifests_path = "tests"
	puppet.manifest_file  = "plugin.pp"
	puppet.module_path = ["../"]
  end
end
