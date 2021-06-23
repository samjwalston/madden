class CreatePlayerContracts < ActiveRecord::Migration[6.1]
  def change
    create_table :player_contracts, id: false do |t|
      t.bigint :id, primary_key: true
      t.bigint :player_id
      t.integer :contract_year
      t.money :cap_hit
      t.money :salary
      t.money :bonus
    end
  end
end
