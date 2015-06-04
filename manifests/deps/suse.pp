# == Class: rbenv::deps::suse
#
# This module manages rbenv dependencies for suse $::osfamily.
#
class rbenv::deps::suse {
  if ! defined(Package['binutils']) {
    package { 'binutils': ensure => present }
  }

  if ! defined(Package['gcc']) {
    package { 'gcc': ensure => present }
  }

  if ! defined(Package['automake']) {
    package { 'automake': ensure => present }
  }

  if ! defined(Package['openssl-devel']) {
    package { 'openssl-devel': ensure => present }
  }

  if ! defined(Package['zlib-devel']) {
    package { 'zlib-devel': ensure => present }
  }

  if ! defined(Package['libffi-devel']) {
    package { 'libffi-dev': ensure => present }
  }

  if ! defined(Package['libyaml-devel']) {
    package { 'libyaml-dev': ensure => present }
  }

  if ! defined(Package['ncurses-devel']) {
    package { 'ncurses-dev': ensure => present }
  }

  if ! defined(Package['readline-devel']) {
    package { 'readline-dev': ensure => present }
  }

  if ! defined(Package['gdbm-devel']) {
    package { 'gdbm-dev': ensure => present }
  }
}
