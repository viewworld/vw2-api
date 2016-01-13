class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  rescue_from CanCan::AccessDenied do |exception|
    render json: { errors: exception.message }, status: 403
  end

  def current_user
    if user_id = $redis.hget(request.headers['Authorization'], 'User_id')
      @current_user ||= User.find_by(id: user_id)
    end
  end

  def authenticate_with_token!
    unless current_user.present?
      render json: { errors: "not authenticated" }, status: 401
    end
  end
end
