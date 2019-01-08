class CreateLeagues < ActiveRecord::Migration[5.1]
  def up
    create_table :leagues, id: false do |t|
      t.bigint :id, primary_key: true
      t.string :name
    end
  end

  def down
    drop_table :leagues
  end
end
