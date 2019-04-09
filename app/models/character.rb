class Character < ApplicationRecord
  validates :pseudonyme, presence: true

  belongs_to :account
  belongs_to :camp
end
