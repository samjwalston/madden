class Prospect < ApplicationRecord
  has_many :archetypes, class_name: "ProspectArchetype"
end
