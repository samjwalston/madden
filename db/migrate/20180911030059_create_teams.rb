class CreateTeams < ActiveRecord::Migration[5.1]
  def up
    create_table :teams, id: false do |t|
      t.bigint :id, primary_key: true
      t.string :name
      t.string :conference
      t.string :division
      t.integer :overall_rating
      t.integer :offense_rating
      t.integer :defense_rating
      t.integer :specialteams_rating
      t.integer :quarterback_rating
      t.integer :rushing_rating
      t.integer :receiver_rating
      t.integer :passprotect_rating
      t.integer :passrush_rating
      t.integer :rundefense_rating
      t.integer :passcoverage_rating
    end
  end

  def down
    drop_table :teams
  end
end
