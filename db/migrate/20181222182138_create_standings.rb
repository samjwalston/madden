class CreateStandings < ActiveRecord::Migration[5.1]
  def up
    create_table :standings, id: false do |t|
      t.bigint :id, primary_key: true # "#{league_id}:#{team_id}:#{calendar_year}"
      t.bigint :conference_id
      t.bigint :division_id
      t.bigint :team_id
      t.integer :away_losses
      t.integer :away_ties
      t.integer :away_wins
      t.integer :calendar_year
      t.integer :conf_losses
      t.integer :conf_ties
      t.integer :conf_wins
      t.integer :def_pass_yds
      t.integer :def_pass_yds_rank
      t.integer :def_rush_yds
      t.integer :def_rush_yds_rank
      t.integer :def_total_yds
      t.integer :def_total_yds_rank
      t.integer :div_losses
      t.integer :div_ties
      t.integer :div_wins
      t.integer :home_losses
      t.integer :home_ties
      t.integer :home_wins
      t.integer :net_pts
      t.integer :off_pass_yds
      t.integer :off_pass_yds_rank
      t.integer :off_rush_yds
      t.integer :off_rush_yds_rank
      t.integer :off_total_yds
      t.integer :off_total_yds_rank
      t.integer :pts_against_rank
      t.integer :pts_for_rank
      t.integer :playoff_status
      t.integer :prev_rank
      t.integer :pts_against
      t.integer :pts_against
      t.integer :pts_for
      t.integer :rank
      t.integer :seed
      t.integer :season_index
      t.integer :stage_index
      t.integer :total_losses
      t.integer :total_ties
      t.integer :total_wins
      t.integer :t_o_diff
      t.integer :week_index
      t.integer :win_loss_streak
      t.decimal :win_pct
      t.string :conference_name
      t.string :division_name
      t.string :team_name
    end
  end

  def down
    drop_table :standings
  end
end
