module SessionHelper
  def valid_access
    valid_tokens[:access]
  end

  def valid_refresh
    valid_tokens[:refresh]
  end

  def valid_headers
    {
      "#{JWTSessions.access_header}": valid_access
    }
  end

  def account_from_headers
    @account_from_headers ||= create :account, email: 'uniq@example.com'
  end

  private

  def valid_tokens
    payload = { account_id: account_from_headers.id }
    session = JWTSessions::Session.new(payload: payload, refresh_payload: payload)
    session.login
  end
end
