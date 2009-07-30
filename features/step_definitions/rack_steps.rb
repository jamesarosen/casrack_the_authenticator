require File.join(File.dirname(__FILE__), '..', '..', 'test', 'test_helper.rb')
require 'rack/mock'

Given /^a Rack application exists$/ do
  @underlying_app = lambda { |env| nil }
  @app = @underlying_app
end

Given /^the simple version of Casrack the Authenticator is installed$/ do
  @app = CasrackTheAuthenticator::Simple.new(@underlying_app, :cas_server => 'http://cas.test/cas')
end

Given /^the underlying Rack application returns (.+)$/ do |response|
  @underlying_app.stubs(:call).returns(eval(response))
end

When /^I make a request$/ do
  When 'I make a request to "/"'
end

When /^I make a request to "(.+)"$/ do |path|
  @response = Rack::MockRequest.new(@app).get path
end

Then /^the response should be successful$/ do
  assert((200..299).include?(@response.status))
end

Then /^the response body should include "([^\"]*)"$/ do |text|
  assert @response.body.include?(text)
end

Then /^I should be redirected to CAS$/ do
  assert((300..399).include?(@response.status))
  redirected_to = @response.headers['Location']
  assert !redirected_to.nil?
  assert redirected_to =~ /cas/i
end

Then /^CAS should return me to "([^\"]*)"$/ do |return_to|
  redirected_to = URI::parse(@response.headers['Location'])
  params = Rack::Utils.parse_nested_query(redirected_to.query)
  assert_equal return_to, params['service']
end
