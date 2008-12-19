# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  before_filter :fetch_logged_in_user

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '3b6f606f82ab7b57427ba00ab0572bf1'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  protected

  def fetch_logged_in_user
    return unless session[:user_id]
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def logged_in?
    !@current_user.nil?
  end
  helper_method :logged_in?

  def login_required
    return true if logged_in?
    session[:return_to] = request.request_uri
    redirect_to login_url and return false 
  end

  def fading_flash_message(text, seconds=3)
    text +
      <<-EOJS
      <script type=‘text/javascript’>
        Event.observe(window, ‘load’,function() {
          setTimeout(function() {
            message_id = $(‘notice’) ? ‘notice’ : ‘warning’;
            alert(message_id);
            new Effect.Fade(message_id);
          }, #{seconds*1000});
        }, false);
      </script>
    EOJS
  end
end
