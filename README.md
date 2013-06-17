# puppet-rbenv

## Description
This Puppet module will install and manage rbenv on Ubuntu. Additionally,
you can install rbenv plugins and ruby gems.

## Usage
To use this module, you must declare it in your manifest like so:

    class { 'rbenv': }

If you wish to install rbenv somewhere other than the default
(`/usr/local/rbenv`), you can do so by declaring the `install_dir`:

    class { 'rbenv': install_dir => '/opt/rbenv' }

The class will merely setup rbenv on your host. If you wish to install
plugins or gems, you will have to add those declarations to your manifests
as well.

## Plugins
Plugins can be installed from GitHub using the following definiton:

    rbenv::plugin { 'github_user/github_repo': }

### Installing and using ruby-build

To install rubies you will need the [ruby-build](https://github.com/sstephenson/ruby-build) plugin 
from @sstephenson. Once installed, you can install most any Ruby. Additionally,
you can set the ruby to be the global interpreter.

    rbenv::plugin { 'sstephenson/ruby-build': }->
    rbenv::build { '2.0.0-p195': global => true }

## Gems
Gems can be installed too! You *must* specify the `ruby_version` you want to
install for.

    rbenv::gem { 'thor': ruby_version => '2.0.0-p195' }

## Requirements
You will need to install the [git module](https://github.com/puppetlabs/puppetlabs-git) from Puppetlabs.

## Example
site.pp

    class { 'git': }
    class { 'rbenv': }->rbenv::plugin { [ 'sstephenson/rbenv-vars', 'sstephenson/ruby-build' ]: }
    rbenv::build { '2.0.0-p195': global => true }
    rbenv::gem { 'thor': ruby_version   => '2.0.0-p195' }

## Testing

In order to successfully run `vagrant up`, this repository directory
must be called `rbenv`, not `puppet-rbenv`.

    $ git clone https://github.com/justindowning/puppet-rbenv rbenv
    $ cd rbenv
    $ git submodule init && git submodule update
    $ vagrant up
