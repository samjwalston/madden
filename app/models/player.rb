class Player < ApplicationRecord
  has_many :archetypes
  has_one :role
end
