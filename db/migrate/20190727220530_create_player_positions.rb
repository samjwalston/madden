class CreatePlayerPositions < ActiveRecord::Migration[5.1]
  def change
    create_table :player_positions, id: false do |t|
      t.string :id, primary_key: true
      t.decimal :rating
    end
  end
end
