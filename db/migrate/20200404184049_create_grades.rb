class CreateGrades < ActiveRecord::Migration[5.1]
  def change
    create_table :grades, id: false do |t|
      t.bigint :id, primary_key: true
      t.bigint :prospect_id
      t.string :archetype
      t.string :letter
      t.integer :rating
    end
  end
end
