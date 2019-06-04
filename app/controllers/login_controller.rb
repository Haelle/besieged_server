class LoginController < ApplicationController
  def login_with_id
    @account = Account.find params[:id]
    render_jwt_session
  rescue ActiveRecord::RecordNotFound
    render_account_not_foud
  end

  def login_with_email
    @account = Account.find_by! email: params[:email]
    render_jwt_session
  rescue ActiveRecord::RecordNotFound
    render_account_not_foud
  end

  private

  def render_jwt_session
    if authenticated?
      render json: jwt_session.login
    else
      render json: { error: 'wrong password' }, status: :unauthorized
    end
  end

  def authenticated?
    @account.authenticate(params[:password])
  end

  def jwt_session
    JWTSessions::Session.new(payload: payload, refresh_payload: payload)
  end

  def payload
    { account_id: @account.id }
  end

  def render_account_not_foud
    render json: { error: 'account not found' }, status: :not_found
  end
end
