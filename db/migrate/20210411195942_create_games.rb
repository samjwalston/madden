class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games, id: false do |t|
      t.string :id, primary_key: true # 'season:week:slot'
      t.integer :season
      t.integer :week
      t.integer :slot
      t.string :home_team
      t.integer :home_rating
      t.string :away_team
      t.integer :away_rating
      t.decimal :line
    end
  end
end
