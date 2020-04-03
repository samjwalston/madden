class CreateArchetypes < ActiveRecord::Migration[5.1]
  def change
    create_table :archetypes, id: false do |t|
      t.bigint :id, primary_key: true
      t.bigint :player_id
      t.string :name
      t.integer :overall_rating
    end
  end
end
