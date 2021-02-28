class Team < ApplicationRecord
  has_one :coach
  has_many :players
end
