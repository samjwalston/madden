class CreateArchetypes < ActiveRecord::Migration[5.1]
  def change
    create_table :archetypes, id: false do |t|
      t.integer :id, primary_key: true
      t.string :position
      t.string :name
      t.integer :accel_rating, default: 0
      t.integer :agility_rating, default: 0
      t.integer :aware_rating, default: 0
      t.integer :b_cv_rating, default: 0
      t.integer :block_shed_rating, default: 0
      t.integer :break_sack_rating, default: 0
      t.integer :break_tackle_rating, default: 0
      t.integer :carry_rating, default: 0
      t.integer :catch_rating, default: 0
      t.integer :c_it_rating, default: 0
      t.integer :throw_acc_deep_rating, default: 0
      t.integer :route_run_deep_rating, default: 0
      t.integer :elusive_rating, default: 0
      t.integer :finesse_moves_rating, default: 0
      t.integer :hit_power_rating, default: 0
      t.integer :impact_block_rating, default: 0
      t.integer :injury_rating, default: 0
      t.integer :juke_move_rating, default: 0
      t.integer :jump_rating, default: 0
      t.integer :kick_acc_rating, default: 0
      t.integer :kick_power_rating, default: 0
      t.integer :kick_ret_rating, default: 0
      t.integer :lead_block_rating, default: 0
      t.integer :man_cover_rating, default: 0
      t.integer :throw_acc_mid_rating, default: 0
      t.integer :route_run_med_rating, default: 0
      t.integer :pass_block_rating, default: 0
      t.integer :pass_block_finesse_rating, default: 0
      t.integer :pass_block_power_rating, default: 0
      t.integer :play_action_rating, default: 0
      t.integer :play_rec_rating, default: 0
      t.integer :power_moves_rating, default: 0
      t.integer :press_rating, default: 0
      t.integer :pursuit_rating, default: 0
      t.integer :release_rating, default: 0
      t.integer :run_block_rating, default: 0
      t.integer :run_block_finesse_rating, default: 0
      t.integer :run_block_power_rating, default: 0
      t.integer :throw_acc_short_rating, default: 0
      t.integer :route_run_short_rating, default: 0
      t.integer :spec_catch_rating, default: 0
      t.integer :speed_rating, default: 0
      t.integer :spin_move_rating, default: 0
      t.integer :stamina_rating, default: 0
      t.integer :stiff_arm_rating, default: 0
      t.integer :strength_rating, default: 0
      t.integer :tackle_rating, default: 0
      t.integer :throw_on_run_rating, default: 0
      t.integer :throw_power_rating, default: 0
      t.integer :throw_under_pressure_rating, default: 0
      t.integer :tough_rating, default: 0
      t.integer :truck_rating, default: 0
      t.integer :zone_cover_rating, default: 0
    end
  end
end
