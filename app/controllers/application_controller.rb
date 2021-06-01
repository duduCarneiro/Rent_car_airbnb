class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pundit

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:user_name])
  end

  after_action :verify_authorized, except: :home, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :home, unless: :skip_pundit?
  
  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
