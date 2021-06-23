class CreateProspects < ActiveRecord::Migration[6.1]
  def change
    create_table :prospects, id: false do |t|
      t.bigint :id, primary_key: true
      t.string :name
      t.string :position
      t.string :role
      t.string :style
      t.string :development_trait
      t.string :grade
      t.integer :age
      t.integer :draft_round
      t.integer :draft_pick
      t.decimal :value
    end
  end
end
