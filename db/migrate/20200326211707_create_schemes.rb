class CreateSchemes < ActiveRecord::Migration[5.1]
  def change
    create_table :schemes, id: false do |t|
      t.integer :id, primary_key: true
      t.string :name
    end
  end
end
