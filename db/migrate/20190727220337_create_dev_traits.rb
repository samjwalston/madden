class CreateDevTraits < ActiveRecord::Migration[5.1]
  def change
    create_table :dev_traits, id: false do |t|
      t.integer :id, primary_key: true
      t.decimal :rating
    end
  end
end
