class CreateContracts < ActiveRecord::Migration[5.1]
  def change
    create_table :contracts, id: false do |t|
      t.bigint :id, primary_key: true
      t.bigint :player_id
      t.integer :contract_year
      t.money :salary
      t.money :bonus
    end
  end
end
