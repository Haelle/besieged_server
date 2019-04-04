class Account < ApplicationRecord
  has_secure_password

  def as_json(options = {})
    super.tap { |h| h.delete('password_digest') }
  end
end
