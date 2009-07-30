require File.join(File.dirname(__FILE__), 'test_helper')

class BasicTest < Test::Unit::TestCase
  
  context 'a Basic authenticator' do
    
    setup do
      @app = Object.new
      @authenticator = CasrackTheAuthenticator::Basic.new(@app, {})
    end
    
    context 'when receiving a 200 from below' do
      
      setup do
        @response = [ 200, Object.new, Object.new ]
        @app.stubs(:call).returns(@response)
      end
      
      should 'pass the request to the underyling app' do
        @authenticator.call({})
        assert_received(@app, :call)
      end
      
      should 'do nothing to the response' do
        assert_equal @response, @authenticator.call({})
      end
      
    end
    
  end
  
end
