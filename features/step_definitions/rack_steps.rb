require File.join(File.dirname(__FILE__), '..', '..', 'test', 'test_helper.rb')
require 'rack/mock'

Given /^a Rack application exists$/ do
  self.underlying_app = lambda { |env| nil }
  self.app = underlying_app
end

Given /^the simple version of Casrack the Authenticator is installed$/ do
  self.app = CasrackTheAuthenticator::Simple.new(app, :cas_server => 'http://cas.test/cas')
end

Given /^the RequireCAS middleware is installed$/ do
  self.app = CasrackTheAuthenticator::RequireCAS.new(app)
end

Given /^the underlying Rack application returns (.+)$/ do |response|
  underlying_app.stubs(:call).returns(eval(response))
end

When /^I make a request$/ do
  get '/'
end

When /^I make a request to "([^\"]*)"$/ do |url|
  get url
end

When /^I return to "([^\"]*)" with a valid CAS ticket for "([^\"]*)"$/ do |url, user|
  http_request_returns_valid_cas_user user
  url << (url.include?('?') ? '&' : '?') << 'ticket=ST-123455'
  When "I make a request to \"#{url}\""
end

When /^I return to "([^\"]*)" with an invalid CAS ticket$/ do |url|
  http_request_returns_error
  url << (url.include?('?') ? '&' : '?') << 'ticket=ST-not-a-valid-ticket'
  When "I make a request to \"#{url}\""
end

Then /^the CAS user should be nil$/ do
  assert_equal nil, session[:cas_user]
end

Then /^the CAS user should be "([^\"]*)"$/ do |username|
  assert_equal username, session[:cas_user]
end

Then /^the response should be successful$/ do
  assert((200..299).include?(response.status), "Expected success, but was #{response.status}")
end

Then /^the response body should include "([^\"]*)"$/ do |text|
  assert response.body.include?(text)
end

Then /^I should be redirected to CAS$/ do
  assert((300..399).include?(response.status), "Expected redirect, but was #{response.status}")
  assert !redirected_to.nil?
  assert redirected_to.to_s =~ /cas/i
end

Then /^CAS should return me to "([^\"]*)"$/ do |return_to|
  assert_equal return_to, service_url
end
