class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :authorize
  
  delegate :allow?, to: :current_permission
  
  private
    
    # Cache user's permission struct in instance variable
    def current_permission
      @current_permission ||= Permission.new(current_user)
    end
    
    # Allow authorized paths
    def authorize
      allow = current_permission.allow?(params[:controller], params[:action], params)
      if allow
        # Set variables to prevent multiple Model.find lookups
        set_instance_variables(allow)
      else
        redirect_to root_url, notice: 'Not authorized.'
      end
    end
    
    # Set instance variables from hash
    def set_instance_variables(hash)
      if hash.class == Hash
        hash.each_pair do |key, value|
          self.instance_variable_set("@#{key}", value)
        end
      end
    end
  
end
