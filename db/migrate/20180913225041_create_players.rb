class CreatePlayers < ActiveRecord::Migration[5.1]
  def up
    create_table :players, id: false do |t|
      t.string :id, primary_key: true
      t.bigint :presentation_id
      t.bigint :player_id
      t.bigint :team_id
      t.integer :accel_rating
      t.integer :age
      t.integer :agility_rating
      t.integer :aware_rating
      t.integer :b_cv_rating
      t.integer :big_hit_trait
      t.integer :birth_day
      t.integer :birth_month
      t.integer :birth_year
      t.integer :block_shed_rating
      t.integer :break_sack_rating
      t.integer :break_tackle_rating
      t.integer :c_it_rating
      t.integer :cap_hit
      t.integer :cap_release_net_savings
      t.integer :cap_release_penalty
      t.integer :carry_rating
      t.integer :catch_rating
      t.integer :clutch_trait
      t.integer :conf_rating
      t.integer :contract_bonus
      t.integer :contract_length
      t.integer :contract_salary
      t.integer :contract_years_left
      t.integer :cover_ball_trait
      t.integer :d_l_bull_rush_trait
      t.integer :d_l_spin_trait
      t.integer :d_l_swim_trait
      t.integer :desired_bonus
      t.integer :desired_length
      t.integer :desired_salary
      t.integer :dev_trait
      t.integer :draft_pick
      t.integer :draft_round
      t.integer :drop_open_pass_trait
      t.integer :durability_grade
      t.integer :elusive_rating
      t.integer :experience_points
      t.integer :feet_in_bounds_trait
      t.integer :fight_for_yards_trait
      t.integer :finesse_moves_rating
      t.integer :force_pass_trait
      t.integer :h_p_catch_trait
      t.integer :height
      t.integer :high_motor_trait
      t.integer :hit_power_rating
      t.integer :home_state
      t.integer :impact_block_rating
      t.integer :injury_length
      t.integer :injury_rating
      t.integer :injury_type
      t.integer :intangible_grade
      t.integer :jersey_num
      t.integer :juke_move_rating
      t.integer :jump_rating
      t.integer :kick_acc_rating
      t.integer :kick_power_rating
      t.integer :kick_ret_rating
      t.integer :l_b_style_trait
      t.integer :lead_block_rating
      t.integer :legacy_score
      t.integer :man_cover_rating
      t.integer :pass_block_finesse_rating
      t.integer :pass_block_power_rating
      t.integer :pass_block_rating
      t.integer :penalty_trait
      t.integer :physical_grade
      t.integer :play_action_rating
      t.integer :play_ball_trait
      t.integer :play_rec_rating
      t.integer :player_best_ovr
      t.integer :player_scheme_ovr
      t.integer :portrait_id
      t.integer :pos_catch_trait
      t.integer :power_moves_rating
      t.integer :predict_trait
      t.integer :press_rating
      t.integer :production_grade
      t.integer :pursuit_rating
      t.integer :q_b_style_trait
      t.integer :re_sign_status
      t.integer :release_rating
      t.integer :rookie_year
      t.integer :route_run_deep_rating
      t.integer :route_run_med_rating
      t.integer :route_run_short_rating
      t.integer :run_block_finesse_rating
      t.integer :run_block_power_rating
      t.integer :run_block_rating
      t.integer :run_style
      t.integer :scheme
      t.integer :sense_pressure_trait
      t.integer :size_grade
      t.integer :skill_points
      t.integer :spec_catch_rating
      t.integer :speed_rating
      t.integer :spin_move_rating
      t.integer :stamina_rating
      t.integer :stiff_arm_rating
      t.integer :strength_rating
      t.integer :strip_ball_trait
      t.integer :tackle_rating
      t.integer :team_scheme_ovr
      t.integer :throw_acc_deep_rating
      t.integer :throw_acc_mid_rating
      t.integer :throw_acc_rating
      t.integer :throw_acc_short_rating
      t.integer :throw_away_trait
      t.integer :throw_on_run_rating
      t.integer :throw_power_rating
      t.integer :throw_under_pressure_rating
      t.integer :tight_spiral_trait
      t.integer :tough_rating
      t.integer :truck_rating
      t.integer :weight
      t.integer :y_ac_catch_trait
      t.integer :years_pro
      t.integer :zone_cover_rating
      t.string :college
      t.string :first_name
      t.string :home_town
      t.string :last_name
      t.string :position
      t.boolean :is_active
      t.boolean :is_free_agent
      t.boolean :is_on_ir
      t.boolean :is_on_practice_squad
    end
  end

  def down
    drop_table :players
  end
end
