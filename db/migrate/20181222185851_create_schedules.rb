class CreateSchedules < ActiveRecord::Migration[5.1]
  def up
    create_table :schedules, id: false do |t|
      t.string :id, primary_key: true # "#{league_id}:#{schedule_id}"
      t.bigint :away_team_id
      t.bigint :home_team_id
      t.bigint :schedule_id
      t.integer :away_score
      t.integer :home_score
      t.integer :season_index
      t.integer :stage_index
      t.integer :status
      t.integer :week_index
      t.boolean :is_game_of_the_week
    end
  end

  def down
    drop_table :schedules
  end
end
