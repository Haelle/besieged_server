class LoginController < ApplicationController
  def create
    account = Account.find_by!(email: params[:email])
    if account.authenticate(params[:password])
      payload = { account_id: account.id }
      session = JWTSessions::Session.new(payload: payload)
      render json: session.login
    else
      render json: 'Invalid user', status: :unauthorized
    end
  end
end
