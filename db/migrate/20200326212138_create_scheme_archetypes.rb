class CreateSchemeArchetypes < ActiveRecord::Migration[5.1]
  def change
    create_table :scheme_archetypes, id: false do |t|
      t.integer :id, primary_key: true
      t.integer :scheme_id
      t.integer :archetype_id
    end
  end
end
