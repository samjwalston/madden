class CreateTeams < ActiveRecord::Migration[5.1]
  def up
    create_table :teams, id: false do |t|
      t.bigint :id, primary_key: true
      t.string :name
      t.string :conference
      t.string :division
      t.decimal :overall_rating
      t.decimal :offense_rating
      t.decimal :defense_rating
      t.decimal :specialteams_rating
      t.decimal :quarterback_rating
      t.decimal :rushing_rating
      t.decimal :receiver_rating
      t.decimal :passprotect_rating
      t.decimal :passrush_rating
      t.decimal :rundefense_rating
      t.decimal :passcoverage_rating
    end
  end

  def down
    drop_table :teams
  end
end
