# -*- mode: ruby -*-
# vi: set ft=ruby :

$script =<<-SCRIPT
if [ -e /etc/debian_version ]; then
  apt-get update
  apt-get install -y lsb-release wget
  wget https://apt.puppetlabs.com/puppet6-release-$(lsb_release -c | awk '{print $NF}').deb
  dpkg -i puppet6-release-$(lsb_release -c | awk '{print $NF}').deb
  apt-get update && apt-get install -y puppet-agent
else
  yum update
  yum install -y wget
  wget https://apt.puppetlabs.com/puppet6-release-el-7.noarch.rpm
  rpm -Uvh https://yum.puppet.com/puppet6-release-el-7.noarch.rpm
  yum update && yum install -y puppet-agent
fi

     
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.hostname = 'puppet-rbenv'
  config.vm.synced_folder "modules", "/tmp/puppet-modules", type: "rsync", rsync__exclude: ".git/"
  config.vm.synced_folder ".", "/tmp/puppet-modules/rbenv", type: "rsync", rsync__exclude: [".git/","spec/"]

  config.vm.provision "shell", inline: $script

  config.vm.provision :puppet do |puppet|
    puppet.environment_path = "examples"
    puppet.environment = "vagrant"
    puppet.options        = ["--modulepath", "/tmp/puppet-modules"]
  end

  config.vm.define "centos" do |centos|
    centos.vm.box = 'geerlingguy/centos7'
  end

  config.vm.define "ubuntu", primary: true do |ubuntu|
    ubuntu.vm.box = 'ubuntu/bionic64'
  end

end
