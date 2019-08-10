class CreatePlayerDrafts < ActiveRecord::Migration[5.1]
  def change
    create_table :player_drafts, id: false do |t|
      t.integer :id, primary_key: true
      t.decimal :rating
    end
  end
end
