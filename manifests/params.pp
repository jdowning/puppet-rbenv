# == Class: rbenv::params
#
class rbenv::params {

  $repo_path          = 'git://github.com/sstephenson/rbenv.git'
  $repo_name          = 'rbenv'
  $install_prefix     = '/usr/local'
  $install_dir        = "${install_prefix}/${repo_name}"

}
