class Player < ApplicationRecord
  belongs_to :team
  has_many :archetypes, class_name: "PlayerArchetype"
  has_one :contract, ->(player){where(contract_year: player.contract_year)}, class_name: "PlayerContract"
end
