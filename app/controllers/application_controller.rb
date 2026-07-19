class ApplicationController < ActionController::API
  before_action :authenticate_user!

  attr_reader :current_user

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable
  rescue_from ActionController::ParameterMissing, with: :bad_request
  rescue_from GithubClient::Error, with: :service_error
  rescue_from GithubOAuthService::Error, with: :service_error
  rescue_from GroqReviewService::Error, with: :service_error

  private

  def authenticate_user!
    token = request.authorization.to_s.delete_prefix("Bearer ").presence
    digest = User.digest_token(token) if token
    @current_user = User.find_by(session_token_digest: digest) if digest
    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end

  def not_found
    render json: { error: "Not found" }, status: :not_found
  end

  def bad_request(error)
    render json: { error: error.message }, status: :bad_request
  end

  def unprocessable(error)
    render json: { error: error.record.errors.full_messages.to_sentence }, status: :unprocessable_entity
  end

  def service_error(error)
    render json: { error: error.message }, status: :bad_gateway
  end
end
