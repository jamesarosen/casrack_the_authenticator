require 'rack'
require 'rack/mock'
Rack::MockRequest.class_eval do
  
  class <<self
    def env_for_with_hook(*args)
      return ::RackSupport.current_env unless ::RackSupport.current_env.nil?
      env = env_for_without_hook(*args)
      ::RackSupport.current_env = env
      env
    end
    alias_method :env_for_without_hook, :env_for
    alias_method :env_for, :env_for_with_hook
  end
  
end

module RackSupport
  
  VALID_CAS_USER_XML = <<-EOX
<cas:serviceResponse>
  <cas:authenticationSuccess>
    <cas:user>%s</cas:user>
  </cas:authenticationSuccess>
</cas:serviceResponse>
EOX
  
  @@current_env = nil
  
  def self.current_env
    @@current_env
  end
  
  def self.current_env=(env)
    @@current_env = env
  end
  
  attr_accessor :underlying_app, :app, :response, :session
  
  def cleanup_rack_variables
    ::RackSupport.current_env = nil
    self.underlying_app = self.app = self.session = self.response = nil
  end
  
  def get(url)
    env = RackSupport.current_env = Rack::MockRequest.env_for(url)
    if session
      env['rack.session'] = session
    else
      self.session = Rack::Request.new(env).session
    end
    env['fazbot'] = 'weasel!'
    self.response = Rack::MockRequest.new(app).get url
  end
  
  def redirected_to
    return nil if response.headers['Location'].nil?
    URI::parse(response.headers['Location'])
  end
  
  def service_url
    return nil if redirected_to.nil?
    Rack::Utils.parse_nested_query(redirected_to.query)['service']
  end
  
  def http_request_returns_valid_cas_user(username)
    http_request_returns VALID_CAS_USER_XML % username
  end
  
  def http_request_returns_error
    http_request_returns "this is not a valid CAS service-ticket-validation response!"
  end
  
  def http_request_returns(content)
    server = Object.new
    connection = Object.new
    response = Object.new
    Net::HTTP.stubs(:new).returns(server)
    server.stubs(:start).yields(connection)
    connection.stubs(:get).returns(response)
    response.stubs(:body).returns(content)
  end
  
end

After do
  cleanup_rack_variables
end

World(RackSupport)