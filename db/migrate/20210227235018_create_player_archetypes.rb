class CreatePlayerArchetypes < ActiveRecord::Migration[6.1]
  def change
    create_table :player_archetypes, id: false do |t|
      t.bigint :id, primary_key: true
      t.bigint :player_id
      t.string :name
      t.integer :overall_rating
    end
  end
end
