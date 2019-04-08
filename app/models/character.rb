class Character < ApplicationRecord
  validates :pseudonyme, presence: true

  belongs_to :account
end
