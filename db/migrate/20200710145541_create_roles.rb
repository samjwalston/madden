class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles, id: false do |t|
      t.bigint :id, primary_key: true
      t.bigint :player_id
      t.string :name
      t.string :style
      t.integer :rating
      t.decimal :value
    end
  end
end
