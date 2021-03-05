class CreateProspectArchetypes < ActiveRecord::Migration[6.1]
  def change
    create_table :prospect_archetypes, id: false do |t|
      t.bigint :id, primary_key: true
      t.bigint :prospect_id
      t.string :name
      t.string :grade
    end
  end
end
