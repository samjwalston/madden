class CreatePlayers < ActiveRecord::Migration[5.1]
  def up
    create_table :players, id: false do |t|
      t.bigint :id, primary_key: true
      t.bigint :team_id
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :position
      t.string :development_trait
      t.string :injury_status
      t.integer :age
      t.integer :overall_rating
      t.integer :draft_round
      t.integer :draft_pick
      t.integer :year_drafted
      t.integer :contract_length
      t.integer :contract_year
      t.integer :contract_years_left
      t.money :cap_hit
      t.boolean :is_injured_reserve
    end
  end

  def down
    drop_table :players
  end
end
