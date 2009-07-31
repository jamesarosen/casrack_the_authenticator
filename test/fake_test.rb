require File.join(File.dirname(__FILE__), 'test_helper')

class FakeTest < Test::Unit::TestCase
  
  def self.should_let_the_response_bubble_up_unaltered
    should 'let the response bubble up unaltered' do
      assert_equal @app_response, @response
    end
  end
  
  def self.should_set_the_cas_user_to(user)
    should "set the CAS user to #{user || '<nil>'}" do
      assert_received(@app, :call) do |expects|
        expects.with() do |env|
          assert_equal user, Rack::Request.new(env).session[:cas_user]
          true
        end
      end
    end
  end
  
  def self.should_prompt_http_basic_authentication
    should 'prompt HTTP basic authentication' do
      assert_equal 401, @response[0]
      assert_equal 'Basic realm="CasrackTheAuthenticator::Fake"', @response[1]['WWW-Authenticate']
    end
  end
  
  def auth_headers(user)
    { 'HTTP_AUTHORIZATION' => 'Basic '+ ["#{user}:passw0rd"].pack("m*") }
  end
  
  context 'the Fake authenticator' do
    
    setup do
      @app = Object.new
      @fake = CasrackTheAuthenticator::Fake.new @app, 'jlevitt'
    end
    
    context 'when receiving a non-401 response' do
      
      setup do
        @app_response = [ 320, {}, ["Weird redirection"] ]
        @app.stubs(:call).returns @app_response
        @response = @fake.call({})
      end
      
      should_let_the_response_bubble_up_unaltered
      
    end
    
    context 'when receiving a 401 from below' do
      
      setup do
        @app_response = [ 401, {}, 'Unauthorized!' ]
        @app.stubs(:call).returns @app_response
        @response = @fake.call({})
      end
      
      should_prompt_http_basic_authentication
      
    end
    
    context 'when getting a valid HTTP Basic user in the request' do
      
      setup do
        @app_response = [ 210, {}, ["Success-ish"] ]
        @app.stubs(:call).returns @app_response
        @response = @fake.call(auth_headers('jlevitt'))
      end
      
      should_let_the_response_bubble_up_unaltered
      
      should_set_the_cas_user_to 'jlevitt'
      
    end
    
    context 'when getting an invalid HTTP Basic user in the request' do
      
      setup do
        @app_response = [ 401, {}, [] ]
        @app.stubs(:call).returns @app_response
        @response = @fake.call(auth_headers('zdeschanel'))
      end
      
      should_prompt_http_basic_authentication
      
      should_set_the_cas_user_to nil
      
    end
    
  end
  
end