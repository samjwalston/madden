class CreateTeamRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :team_records, id: false do |t|
      t.bigint :id, primary_key: true
      t.integer :wins
      t.integer :losses
      t.integer :ties
      t.decimal :percentage
    end
  end
end
