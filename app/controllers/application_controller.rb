class ApplicationController < ActionController::API
  include RedisStore

  def authenticate_with_token
    if authenticate_with_http_token { |token, options| RedisStore::hexists(token, 'user') && @token = token }
      @current_user = RedisStore::hgetall(@token).with_indifferent_access
    else
      render json: "Invalid token", status: :unauthorized
    end
  end
end
