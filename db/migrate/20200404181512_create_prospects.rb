class CreateProspects < ActiveRecord::Migration[5.1]
  def change
    create_table :prospects, id: false do |t|
      t.bigint :id, primary_key: true
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :position
      t.string :role
      t.string :grade
      t.integer :age
      t.integer :height
      t.integer :weight
      t.integer :round
      t.integer :pick
      t.decimal :value
    end
  end
end
