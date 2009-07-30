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
  
  context 'a Simple authenticator' do
    
    setup do
      @app = Object.new
      @authenticator = CasrackTheAuthenticator::Simple.new(@app, {:cas_server => 'http://cas.test/'})
    end
    
    context 'when receiving a 200 from below' do
      
      setup do
        @response_from_below = [ 200, Object.new, Object.new ]
        @app.stubs(:call).returns(@response_from_below)
        @response = @authenticator.call({})
      end
      
      should_pass_the_request_on_down

      should 'do nothing to the response' do
        assert_equal @response_from_below, @response
      end
      
    end
    
    context 'when receiving a 401 from below' do
      
      setup do
        response = [401, {}, 'Unauthorized!']
        @app.stubs(:call).returns(response)
        @response = @authenticator.call({})
      end
      
      should_pass_the_request_on_down
      
      should 'redirect to CAS' do
        assert((300..399).include?(@response[0]))
        assert @response[1]['Location'] =~ /cas/i
      end
      
    end
    
  end
  
end
