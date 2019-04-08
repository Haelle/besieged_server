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
    account = find_or_create_account
    payload = { account_id: account.id }
    session = JWTSessions::Session.new(payload: payload, refresh_payload: payload)
    session.login
  end

  def valid_account
    find_or_create_account
  end

  private

  def find_or_create_account
    email = 'uniq@example.com'
    existing_account = Account.find_by email: email
    return existing_account unless existing_account.nil?

    create :account, email: email
  end
end
