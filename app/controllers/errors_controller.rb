class ErrorsController < ApplicationController
  def not_found
    render json: { error: 'not-found' }.to_json, status: 404
  end

  def exception
    render json: { error: 'internal-server-error' }.to_json, status: 500
  end

  def access_denied
    render json: { error: 'You are not authorized to access this page.' }.
      to_json,
      status: 403
  end
end
