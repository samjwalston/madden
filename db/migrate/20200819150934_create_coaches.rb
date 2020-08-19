class CreateCoaches < ActiveRecord::Migration[5.1]
  def change
    create_table :coaches, id: false do |t|
      t.bigint :id, primary_key: true
      t.bigint :team_id
      t.string :name
      t.decimal :overall_rating
      t.decimal :offense_rating
      t.decimal :defense_rating
      t.decimal :specialteams_rating
    end
  end
end
