# == Class: rbenv::deps::suse
#
# This module manages rbenv dependencies for suse $::osfamily.
#
class rbenv::deps::suse {
  if ! defined(Package['binutils']) {
    package { 'binutils': ensure => installed }
  }

  if ! defined(Package['gcc']) {
    package { 'gcc': ensure => installed }
  }

  if ! defined(Package['automake']) {
    package { 'automake': ensure => installed }
  }

  if ! defined(Package['openssl-devel']) {
    package { 'openssl-devel': ensure => installed }
  }

  if ! defined(Package['zlib-devel']) {
    package { 'zlib-devel': ensure => installed }
  }

  if ! defined(Package['libffi-devel']) {
    package { 'libffi-dev': ensure => installed }
  }

  if ! defined(Package['libyaml-devel']) {
    package { 'libyaml-dev': ensure => installed }
  }

  if ! defined(Package['ncurses-devel']) {
    package { 'ncurses-dev': ensure => installed }
  }

  if ! defined(Package['readline-devel']) {
    package { 'readline-dev': ensure => installed }
  }

  if ! defined(Package['gdbm-devel']) {
    package { 'gdbm-dev': ensure => installed }
  }
}
