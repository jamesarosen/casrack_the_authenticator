require File.join(File.dirname(__FILE__), 'test_helper')

class SimpleTest < Test::Unit::TestCase
  
  context 'creating a Simple authenticator' do
    should 'require a :cas_server' do
      assert_raises(ArgumentError) do
        CasrackTheAuthenticator::Simple.new(:anything, {})
      end
    end
  end
  
  def self.should_pass_the_request_on_down
    should "pass the request to the underyling app" do
      assert_received(@app, :call)
    end
  end
  
  def self.should_set_the_cas_user_in_the_session_to(username)
    should "set the CAS user in the session to #{username || '<nil>'}" do
      assert_equal username, @session[:cas_user]
    end
  end
  
  def get(url)
    env = Rack::MockRequest.env_for(url)
    if @session
      env['rack.session'] = @session
    else
      @session = Rack::Request.new(env).session
    end
    Rack::MockRequest.stubs(:env_for).returns(env)
    @response = @request.get url
  end
  
  def param_from_url(param, url)
    uri = URI.parse(url)
    Rack::Utils.parse_nested_query(uri.query)[param]
  end
  
  def return_to_url(response)
    param_from_url 'service', response.headers['Location']
  end
  
  context 'a Simple authenticator' do
    
    setup do
      @app = Object.new
      @authenticator = CasrackTheAuthenticator::Simple.new(@app, {:cas_server => 'http://cas.test/'})
      @request = Rack::MockRequest.new(@authenticator)
    end
    
    context 'when receiving a 200 from below' do
      
      setup do
        @response_from_below = [ 200, {}, 'Success!' ]
        @app.stubs(:call).returns(@response_from_below)
        get '/'
      end
      
      should_pass_the_request_on_down

      should 'do nothing to the response' do
        assert_equal @response_from_below[0], @response.status
        assert_equal @response_from_below[2], @response.body
      end
      
    end
    
    context 'when receiving a 401 from below' do
      
      setup do
        response = [401, {}, 'Unauthorized!']
        @app.stubs(:call).returns(response)
        @url = "http://foo.bar/baz?yoo=hoo"
        get @url
      end
      
      should_pass_the_request_on_down
      
      should 'redirect to CAS' do
        assert((300..399).include?(@response.status))
        assert @response.headers['Location'] =~ /cas/i
      end
      
      should 'use the requested URL for the return-to' do
        assert_equal @url, return_to_url(@response)
      end
      
      context "and the request URL includes a 'ticket' param" do
        
        setup do
          @url = "http://foo.bar/baz?ticket=12345"
          get @url
        end
        
        should 'strip the ticket from the return-to URL' do
          return_to = return_to_url(@response)
          assert_equal nil, param_from_url('ticket', return_to)
        end
        
      end
      
    end
    
    context 'when receiving a valid result from CAS' do
      
      setup do
        validator = Object.new
        validator.stubs(:user).returns 'timmy'
        CasrackTheAuthenticator::ServiceTicketValidator.stubs(:new).returns(validator)
        @response_from_below = [ 200, {}, 'Success!' ]
        @app.stubs(:call).returns(@response_from_below)
        get '/?ticket=ST-77889'
      end
      
      should_set_the_cas_user_in_the_session_to 'timmy'
      
      should 'build a service-ticket validator' do
        assert_received(CasrackTheAuthenticator::ServiceTicketValidator, :new)
      end
      
    end
    
  end
  
end
