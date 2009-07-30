require File.join(File.dirname(__FILE__), '..', '..', 'test', 'test_helper.rb')

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
  @response = @app.call({})
end

Then /^the response should be successful$/ do
  assert((200..299).include?(@response[0]))
end

Then /^the response body should include "([^\"]*)"$/ do |text|
  assert @response[2].include?(text)
end

Then /^I should be redirected to CAS$/ do
  assert((300..399).include?(@response[0]))
  redirected_to = @response[1]['Location']
  assert !redirected_to.nil?
  assert redirected_to =~ /cas/i
end
