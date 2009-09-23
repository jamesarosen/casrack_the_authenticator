require File.join(File.dirname(__FILE__), 'test_helper')
require 'net/http'

class ServiceTicketValidatorTest < Test::Unit::TestCase
  
  context 'a service-ticket validator' do
    
    setup do
      config = Object.new
      config.stubs(:service_validate_url).returns('http://cas.example.org/cas/serviceValidate?service=foo&ticket=bar')
      @validator = CasrackTheAuthenticator::ServiceTicketValidator.new(config, nil, nil)
    end
    
    context 'validating a ticket' do
      
      setup do
        @server = Object.new
        @connection = Object.new
        @response = Object.new
        @body = Object.new
        Net::HTTP.stubs(:new).returns(@server)
        @server.stubs(:start).yields(@connection)
        @connection.stubs(:get).returns(@response)
        @response.stubs(:body).returns(@body)
      end
      
      should 'return the body from the service-validate URL' do
        assert_equal @body, @validator.send(:get_validation_response_body)
        assert_received(Net::HTTP, :new) do |expects|
          expects.with('cas.example.org', 80)
        end
        assert_received(@server, :start)
        assert_received(@connection, :get) do |expects|
          expects.with('/cas/serviceValidate?service=foo&ticket=bar', { 'Accept' => '*/*' })
        end
        assert_received(@response, :body)
      end
      
      context "but a connection error gets in the way" do
        
        setup do
          @server.stubs(:start).raises(SocketError)
        end
      
        should 'let the error percolate' do
          assert_raises(SocketError) do
            @validator.send(:get_validation_response_body)
          end
        end
        
      end
      
    end
    
    context 'parsing a successful response' do
      
      setup do
        @body = <<-EOX
<cas:serviceResponse xmlns:cas='http://www.yale.edu/tp/cas'>
  <cas:authenticationSuccess>
    <cas:user>beatrice</cas:user>
  </cas:authenticationSuccess>
</cas:serviceResponse>
EOX
      end
      
      should 'get the user' do
        assert_equal 'beatrice', @validator.send(:parse_user, @body)
      end
    
    end
    
    context 'parsing an unsuccessful response' do
      setup do
        @body = ''
      end
      
      should 'return nil' do
        assert_equal nil, @validator.send(:parse_user, @body)
      end
    end
    
  end
  
end