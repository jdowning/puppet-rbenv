# == Class: rbenv::deps::redhat
#
# This module manages rbenv dependencies for redhat $::osfamily.
#
class rbenv::deps::redhat {
  if ! defined(Package['binutils']) {
    package { 'binutils': ensure => present }
  }

  if ! defined(Package['gcc']) {
    package { 'gcc': ensure => present }
  }

  if ! defined(Package['gcc-c++']) {
    package { 'gcc-c++': ensure => present }
  }

  if ! defined(Package['make']) {
    package { 'make': ensure => present }
  }

  if ! defined(Package['openssl-devel']) {
    package { 'openssl-devel': ensure => present }
  }

  if ! defined(Package['readline-devel']) {
    package { 'readline-devel': ensure => present }
  }

  if ! defined(Package['zlib-devel']) {
    package { 'zlib-devel': ensure => present }
  }

  if ! defined(Package['libffi-devel']) {
    package { 'libffi-devel': ensure => present }
  }

  if ! defined(Package['libyaml-devel']) {
    package { 'libyaml-devel': ensure => present }
  }

  if ! defined(Package['ncurses-devel']) {
    package { 'ncurses-devel': ensure => present }
  }

  if ! defined(Package['gdbm-devel']) {
    package { 'gdbm-devel': ensure => present }
  }
}
