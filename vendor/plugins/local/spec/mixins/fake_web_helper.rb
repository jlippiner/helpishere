require File.dirname(__FILE__) + '/../fake_web/fake_web'

class String#:nodoc:
  def blank?
    empty? || strip.empty?
  end
end

module FakeWebHelper#:nodoc:
  def fake_web(*args)
    options = args.last.is_a?(Hash) ? args.pop.symbolize_keys : {:status => [200, 'OK']}
    # Expand the file path if a file is given.
    options[:file] = File.join(File.dirname(__FILE__), '/../fixtures/fake_web', options[:file]) if options[:file]
    
    begin
      args.each do |url|
        # Register the URI.
        uri = URI.parse(url.to_s)
        uri.path = '/' if uri.path.blank?
        FakeWeb.register_uri(uri, options)
      end
      
      yield if block_given?
    ensure
      stop_fake_web(*args) if block_given?
    end
  end
  alias :with_fake_web :fake_web
  alias :start_fake_web :fake_web
  
  def stop_fake_web(*args)
    if args.empty?
      FakeWeb.clean_registry
    else
      args.each do |url|
        # Delete each URI from the registry.
        uri = URI.parse(url.to_s)
        uri.path = '/' if uri.path.blank?
        FakeWeb::Registry.instance.uri_map.delete(uri)
      end
    end
  end
  
  def http_client_errors(urls = [], &block)
    {
      400 => 'Bad Request',
      401 => 'Unauthorized',
      402 => 'Payment Required',
      403 => 'Forbidden',
      404 => 'Not Found',
      405 => 'Method Not Allowed',
      406 => 'Not Acceptable',
      407 => 'Proxy Authentication Required',
      408 => 'Request Timeout',
      409 => 'Conflict',
      410 => 'Gone',
      411 => 'Length Required',
      412 => 'Precondition Failed',
      413 => 'Request Entity Too Large',
      414 => 'Request-URI Too Long',
      415 => 'Unsupported Media Type',
      416 => 'Requested Range Not Satisfiable',
      417 => 'Expectation Failed'
    }.each do |code, message|
      fake_web(urls, :status => [code, message], &block)
    end
  end
  alias :with_http_client_errors :http_client_errors
  
  def http_server_errors(urls = [], &block)
    {
      500 => 'Internal Server Error',
      501 => 'Not Implemented',
      502 => 'Bad Gateway',
      503 => 'Service Unavailable',
      504 => 'Gateway Timeout',
      505 => 'HTTP Version Not Supported'
    }.each do |code, message|
      fake_web(urls, :status => [code, message], &block)
    end
  end
  alias :with_http_server_errors :http_server_errors
  
  def http_errors(urls = [], &block)
    http_client_errors(urls, &block)
    http_server_errors(urls, &block)
  end
  alias :with_http_errors :http_errors
end
