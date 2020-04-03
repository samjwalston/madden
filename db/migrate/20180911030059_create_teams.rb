class CreateTeams < ActiveRecord::Migration[5.1]
  def up
    create_table :teams, id: false do |t|
      t.bigint :id, primary_key: true
      t.string :name
      t.integer :ovrerall_rating
      t.integer :offense_rating
      t.integer :defense_rating
      t.integer :specialteams_rating
      t.integer :quaterback_rating
      t.integer :runningback_rating
      t.integer :widereceiver_rating
      t.integer :tightend_rating
      t.integer :offensiveline_rating
      t.integer :defensiveline_rating
      t.integer :linebacker_rating
      t.integer :defensiveback_rating
    end
  end

  def down
    drop_table :teams
  end
end
