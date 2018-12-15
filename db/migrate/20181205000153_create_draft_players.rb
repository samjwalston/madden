class CreateDraftPlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :draft_players do |t|
      t.bigint :player_id
      t.bigint :team_id
      t.integer :age
      t.integer :clutch_trait
      t.integer :dev_trait
      t.integer :draft_num
      t.integer :draft_pick
      t.integer :draft_round
      t.integer :intangible_grade
      t.integer :physical_grade
      t.integer :player_best_ovr
      t.integer :player_scheme_ovr
      t.integer :production_grade
      t.integer :scheme
      t.integer :team_scheme_ovr
      t.integer :years_pro
      t.integer :contract_bonus
      t.integer :contract_length
      t.integer :contract_salary
      t.string :name
      t.string :position
    end
  end
end
