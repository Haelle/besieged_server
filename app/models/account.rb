class Account < ApplicationRecord
  has_secure_password
  validates_format_of :email, :with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  cattr_reader :current_password

  def update_with_password(account_params)
    current_password = account_params.delete(:current_password)

    if self.authenticate(current_password)
      self.update(account_params)
      true
    else
      self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      false
    end
  end

  def as_json(options = {})
    super.tap { |h| h.delete('password_digest') }
  end
end
