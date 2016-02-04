class ApplicationController < ActionController::Base
  before_filter :cors_set_access_control_headers
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery

  respond_to :json

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  rescue_from CanCan::AccessDenied do |exception|
    render json: { errors: exception.message }, status: 403
  end

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST,
                                               PATCH,
                                               GET,
                                               DELETE,
                                               PUT,
                                               OPTIONS'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
  end

  def current_user
    if user_id = $redis.hget(request.headers['Authorization'], 'User_id')
      @current_user ||= User.find_by(id: user_id)
    end
  end

  def authenticate_with_token!
    unless current_user.present?
      render json: { errors: "You are not authenticated." }, status: 401
    end
  end
end

