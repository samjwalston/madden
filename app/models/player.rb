class Player < ApplicationRecord
  belongs_to :team
  has_many :archetypes, class_name: "PlayerArchetype"
end
