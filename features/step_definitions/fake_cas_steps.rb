Given /^the fake Casrack middleware is installed with user "([^\"]*)"$/ do |user|
  self.app = CasrackTheAuthenticator::Fake.new(app, user)
end

Then /^I should be presented with a HTTP Basic authentication request$/ do
  assert_equal 401, response.status
  assert_equal 'text/plain', response.headers['Content-Type']
  assert_equal '0', response.headers['Content-Length']
  assert_equal 'Basic realm="CasrackTheAuthenticator::Fake"', response.headers['WWW-Authenticate']
end

When /^I make a request as "([^\"]*)"$/ do |username|
  get '/', { 'HTTP_AUTHORIZATION' => 'Basic ' + ["#{username}:sekret"].pack("m*") }
end
