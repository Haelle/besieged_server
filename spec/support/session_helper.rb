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

  def valid_tokens
    account = create :account
    payload = { account_id: account.id }
    session = JWTSessions::Session.new(payload: payload, refresh_payload: payload)
    tokens = session.login
  end
end
