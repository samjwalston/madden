class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories, id: false do |t|
      t.bigint :id, primary_key: true
      t.bigint :player_id
      t.string :name
      t.integer :rating
    end
  end
end
