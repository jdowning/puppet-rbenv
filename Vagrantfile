# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box     = 'precise64'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'
  config.vm.hostname = 'puppet-rbenv'

  config.vm.provision :puppet do |puppet|
	puppet.manifests_path = "tests"
	puppet.manifest_file  = "build.pp"
	puppet.module_path = ["../"]
  end
end
