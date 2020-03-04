class Account < ApplicationRecord
  has_paper_trail
  has_secure_password
  cattr_reader :current_password

  validates :email,
    uniqueness: true,
    allow_nil: true,
    format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }

  has_many :characters, dependent: :destroy

  def update_with_password(account_params)
    current_password = account_params.delete(:current_password)

    if authenticate(current_password)
      update(account_params)
    else
      errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      false
    end
  end
end
