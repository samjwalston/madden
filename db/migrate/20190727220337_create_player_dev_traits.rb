class CreatePlayerDevTraits < ActiveRecord::Migration[5.1]
  def change
    create_table :player_dev_traits, id: false do |t|
      t.integer :id, primary_key: true
      t.decimal :rating
    end
  end
end
