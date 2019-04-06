class Character < ApplicationRecord
  validates :pseudonyme, presence: true
end
