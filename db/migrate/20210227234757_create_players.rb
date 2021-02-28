class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players, id: false do |t|
      t.bigint :id, primary_key: true
      t.bigint :team_id
      t.string :name
      t.string :position
      t.string :role
      t.string :style
      t.string :development_trait
      t.string :contract_status
      t.string :injury_status
      t.integer :age
      t.integer :draft_round
      t.integer :draft_pick
      t.integer :year_drafted
      t.integer :years_pro
      t.integer :contract_length
      t.integer :contract_year
      t.integer :contract_years_left
      t.integer :overall_rating
      t.decimal :value
      t.money :cap_hit
      t.money :cap_savings
      t.money :cap_penalty
    end
  end
end
