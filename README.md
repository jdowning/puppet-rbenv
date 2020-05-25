# puppet-rbenv

[![Build Status](https://travis-ci.org/jdowning/puppet-rbenv.png)](https://travis-ci.org/jdowning/puppet-rbenv) [![Puppet Forge](http://img.shields.io/puppetforge/v/jdowning/rbenv.svg?style=flat)](https://forge.puppetlabs.com/jdowning/rbenv)

## Description
This Puppet module will install and manage [rbenv](http://rbenv.org). By default, it installs
rbenv for systemwide use, rather than for a user or project. Additionally,
you can install different versions of Ruby, rbenv plugins, and Ruby gems.

## Installation

`puppet module install --modulepath /path/to/puppet/modules jdowning-rbenv`

## Usage
To use this module, you must declare it in your manifest like so:

    class { 'rbenv': }

If you wish to install rbenv somewhere other than the default
(`/usr/local/rbenv`), you can do so by declaring the `install_dir`:

    class { 'rbenv': install_dir => '/opt/rbenv' }

You can also ensure rbenv is kept up-to-date:

    class { 'rbenv':
      install_dir => '/opt/rbenv'
      latest      => true
    }

The class will merely setup rbenv on your host. If you wish to install
rubies, plugins, or gems, you will have to add those declarations to your manifests
as well.

### Installing Ruby using ruby-build
Ruby requires additional packages to operate properly. Fortunately, this module
will ensure these dependencies are met before installing Ruby. To install Ruby
you will need the [ruby-build](https://github.com/rbenv/ruby-build) plugin. Once
installed, you can install most any Ruby. Additionally, you can set the Ruby to
be the global interpreter.

    rbenv::plugin { 'rbenv/ruby-build': }
    rbenv::build { '2.0.0-p247': global => true }
    
Sometimes Ruby needs to be patched prior to being compiled. puppet-rbenv
currently supports patching from a single file located either on the
Puppet Master or the local filesystem. Therefore, the only accepted paths are those
starting with puppet:/// or file:///.

    rbenv::build { '2.0.0-p247': patch => 'puppet:///modules/rbenv/patch.patch' }
    rbenv::build { '2.0.0-p247': patch => 'file:///path/to/patch.patch' }

## Plugins
Plugins can be installed from GitHub using the following definiton:

    rbenv::plugin { 'github_user/github_repo': }

You can ensure a plugin is kept up-to-date. This is helpful for a plugin like
`ruby-build` so that definitions are always available:

    rbenv::plugin { 'rbenv/ruby-build': latest => true }

## Gems
Gems can be installed too! You *must* specify the `ruby_version` you want to
install for.

    rbenv::gem { 'thor': ruby_version => '2.0.0-p247' }

## Full Example
site.pp

    class { 'rbenv': }
    rbenv::plugin { [ 'rbenv/rbenv-vars', 'rbenv/ruby-build' ]: }
    rbenv::build { '2.0.0-p247':
      rubygems_version => '3.2.1',
      bundler_version => '1.17.3',
      global => true,
    }
    rbenv::gem { 'thor': ruby_version => '2.0.0-p247' }

## Testing
You can run specs in  this module with rspec:

    bundle install
    bundle exec rake spec

Or with Docker:

    docker build -t puppet-rbenv .

## Vagrant

You can also test this module in a Vagrant box. There are two box definitons included in the
Vagrant file for CentOS and Ubuntu testing. You will need to use `librarian-puppet` to setup
dependencies:

    bundle install
    bundle exec librarian-puppet install

To test both boxes:

    vagrant up

To test one distribution:

    vagrant up [centos|ubuntu]
