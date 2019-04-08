class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization
  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

  protected

  def found_account
    Account.find JWTSessions::Token
      .decode(found_token)
      .first['account_id']
  end

  private

  def not_authorized
    render json: { error: 'Not authorized' }, status: :unauthorized
  end
end
