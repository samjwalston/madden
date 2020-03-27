class CreateDraftPositions < ActiveRecord::Migration[5.1]
  def change
    create_table :draft_positions, id: false do |t|
      t.integer :id, primary_key: true
      t.decimal :rating
    end
  end
end
