class CreatePlayerAges < ActiveRecord::Migration[5.1]
  def change
    create_table :player_ages, id: false do |t|
      t.integer :id, primary_key: true
      t.decimal :rating
    end
  end
end
