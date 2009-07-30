require File.join(File.dirname(__FILE__), 'test_helper')

class ConfigurationTest < Test::Unit::TestCase
  
  def new_config
    CasrackTheAuthenticator::Configuration.new @valid_params
  end
  
  context 'a Casrack configuration' do
    
    setup do
      @valid_params = {
        :cas_login_url => 'http://cas.example.org/login',
        :cas_service_validate_url => 'http://cas.example.org/service-validate',
        :cas_server => 'http://cas.example.org'
      }
    end
    
    should 'be invalid with neither a :cas_server nor a :cas_login_url' do
      assert_raises(ArgumentError) do
        @valid_params[:cas_server] = @valid_params[:cas_login_url] = nil
        new_config
      end
    end
    
    should 'be invalid with neither a :cas_server nor a :cas_service_validate_url' do
      assert_raises(ArgumentError) do
        @valid_params[:cas_server] = @valid_params[:cas_service_validate_url] = nil
        new_config
      end
    end
    
    should "be invalid with a :cas_login_url that isn't really a URL" do
      assert_raises(ArgumentError) do
        @valid_params[:cas_login_url] = 'not a URL'
        new_config
      end
    end
    
    should "be invalid with a :cas_service_validate_url that isn't really a URL" do
      assert_raises(ArgumentError) do
        @valid_params[:cas_service_validate_url] = 'not a URL'
        new_config
      end
    end
    
    should 'use the login URL if given' do
      base = @valid_params[:cas_login_url]
      service = 'http://example.org'
      assert_equal base + '?service=http%3A%2F%2Fexample.org', new_config.login_url(service)
    end
    
    should 'use the service-validate URL if given' do
      base = @valid_params[:cas_service_validate_url]
      service = 'http://example.org'
      ticket = 'ST-00192'
      svurl = URI.parse new_config.service_validate_url(service, ticket)
      assert svurl.to_s =~ /^#{base}/
      assert_equal service, Rack::Utils.parse_query(svurl.query)['service']
      assert_equal ticket, Rack::Utils.parse_query(svurl.query)['ticket']
    end
    
    should 'provide a default login URL if none is given' do
      @valid_params[:cas_login_url] = nil
      base = 'http://cas.example.org/login'
      service = 'http://example.org'
      assert_equal base + '?service=http%3A%2F%2Fexample.org', new_config.login_url(service)
    end
    
    should 'provide a default service-validate URL if none is given' do
      @valid_params[:cas_service_validate_url] = nil
      base = 'http://cas.example.org/serviceValidate'
      service = 'http://example.org'
      ticket = 'ST-373737'
      svurl = URI.parse new_config.service_validate_url(service, ticket)
      assert svurl.to_s =~ /^#{base}/
      assert_equal service, Rack::Utils.parse_query(svurl.query)['service']
      assert_equal ticket, Rack::Utils.parse_query(svurl.query)['ticket']
    end
    
  end

end
