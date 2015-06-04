# == Class: rbenv::deps::debian
#
# This module manages rbenv dependencies for Debian $::osfamily.
#
class rbenv::deps::debian {
  if ! defined(Package['build-essential']) {
    package { 'build-essential': ensure => present }
  }

  if ! defined(Package['libreadline6-dev']) {
    package { 'libreadline6-dev': ensure => present }
  }

  if ! defined(Package['libssl-dev']) {
    package { 'libssl-dev': ensure => present }
  }

  if ! defined(Package['zlib1g-dev']) {
    package { 'zlib1g-dev': ensure => present }
  }

  if ! defined(Package['libffi-dev']) {
    package { 'libffi-dev': ensure => present }
  }

  if ! defined(Package['libyaml-dev']) {
    package { 'libyaml-dev': ensure => present }
  }

  if ! defined(Package['libncurses5-dev']) {
    package { 'libncurses5-dev': ensure => present }
  }

  if ! defined(Package['libgdbm3']) {
    package { 'libgdbm3': ensure => present }
  }

  if ! defined(Package['libgdbm-dev']) {
    package { 'libgdbm-dev': ensure => present }
  }
}
