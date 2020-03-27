class CreatePlayerArchetypes < ActiveRecord::Migration[5.1]
  def change
    create_table :player_archetypes, id: false do |t|
      t.string :id, primary_key: true
      t.bigint :player_id
      t.integer :archetype_id
      t.integer :overall
      t.decimal :rating
    end
  end
end
