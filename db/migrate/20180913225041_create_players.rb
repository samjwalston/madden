class CreatePlayers < ActiveRecord::Migration[5.1]
  def up
    create_table :players, id: false do |t|
      t.bigint :id, primary_key: true
      t.bigint :team_id
      t.string :name
      t.string :position
      t.string :development_trait
      t.string :status
      t.string :injury_status
      t.integer :age
      t.integer :overall_rating
      t.integer :draft_round
      t.integer :draft_pick
      t.integer :year_drafted
      t.integer :years_pro
      t.integer :contract_length
      t.integer :contract_year
      t.integer :contract_years_left
      t.money :cap_hit
      t.money :cap_savings
      t.money :cap_penalty
    end
  end

  def down
    drop_table :players
  end
end
