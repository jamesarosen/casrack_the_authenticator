require 'test/unit'
require 'test/unit/testcase'
require 'rubygems'
require 'shoulda'
gem 'jferris-mocha'
require 'mocha'
require 'redgreen'

lib_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$: << lib_path unless $:.include?(lib_path)

require 'casrack_the_authenticator'
require 'rack'
require 'rack/mock'