class CreateSchemePositions < ActiveRecord::Migration[5.1]
  def change
    create_table :scheme_positions, id: false do |t|
      t.integer :id, primary_key: true
      t.integer :scheme_id
      t.string :position
      t.integer :rank
      t.decimal :rating
    end
  end
end
