class ApplicationController < ActionController::API
  class Unauthorized < RuntimeError; end

  include JWTSessions::RailsAuthorization
  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized
  rescue_from Unauthorized,                      with: :not_authorized

  protected

  def found_account
    Account.find payload['account_id']
  end

  def authorize_action_only_to_itself!
    raise Unauthorized unless @character.account == found_account
  end

  private

  def not_authorized
    render json: { error: 'Not authorized' }, status: :unauthorized
  end
end
