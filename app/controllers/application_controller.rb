class ApplicationController < ActionController::Base
  rescue_from ActionController::RoutingError, with: :handle_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    authenticated_root_path
  end

  def handle_not_found
    redirect_to authenticated_root_path, alert: "La página que buscas no existe."
  end
end
