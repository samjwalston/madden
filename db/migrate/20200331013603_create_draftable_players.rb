class CreateDraftablePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :draftable_players, id: false do |t|
      t.bigint :id, primary_key: true
    end
  end
end
