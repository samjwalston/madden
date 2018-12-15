class CreateTeams < ActiveRecord::Migration[5.1]
  def self.up
    create_table :teams, id: false do |t|
      t.bigint :id, primary_key: true
      t.bigint :conference_id
      t.bigint :division_id
      t.bigint :logo_id
      t.integer :away_losses
      t.integer :away_ties
      t.integer :away_wins
      t.integer :calendar_year
      t.integer :cap_available
      t.integer :cap_room
      t.integer :cap_spent
      t.integer :conf_losses
      t.integer :conf_ties
      t.integer :conf_wins
      t.integer :def_pass_yds
      t.integer :def_pass_yds_rank
      t.integer :def_rush_yds
      t.integer :def_rush_yds_rank
      t.integer :def_scheme
      t.integer :def_total_yds
      t.integer :def_total_yds_rank
      t.integer :div_losses
      t.integer :div_ties
      t.integer :div_wins
      t.integer :home_losses
      t.integer :home_ties
      t.integer :home_wins
      t.integer :injury_count
      t.integer :net_pts
      t.integer :off_pass_yds
      t.integer :off_pass_yds_rank
      t.integer :off_rush_yds
      t.integer :off_rush_yds_rank
      t.integer :off_scheme
      t.integer :off_total_yds
      t.integer :off_total_yds_rank
      t.integer :ovr_rating
      t.integer :playoff_status
      t.integer :prev_rank
      t.integer :primary_color
      t.integer :pts_against
      t.integer :pts_against_rank
      t.integer :pts_for
      t.integer :pts_for_rank
      t.integer :rank
      t.integer :season_index
      t.integer :secondary_color
      t.integer :seed
      t.integer :stage_index
      t.integer :t_o_diff
      t.integer :team_ovr
      t.integer :total_losses
      t.integer :total_ties
      t.integer :total_wins
      t.integer :week_index
      t.integer :win_loss_streak
      t.decimal :win_pct
      t.string :abbr_name
      t.string :city_name
      t.string :conference_name
      t.string :display_name
      t.string :div_name
      t.string :division_name
      t.string :nick_name
      t.string :team_name
      t.string :user_name
    end
  end

  def self.down
    drop_table :teams
  end
end
