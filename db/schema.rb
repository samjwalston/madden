# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20200327212230) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ages", id: :integer, default: nil, force: :cascade do |t|
    t.decimal "rating"
  end

  create_table "archetypes", id: :integer, default: nil, force: :cascade do |t|
    t.string "position"
    t.string "name"
    t.integer "accel_rating", default: 0
    t.integer "agility_rating", default: 0
    t.integer "aware_rating", default: 0
    t.integer "b_cv_rating", default: 0
    t.integer "block_shed_rating", default: 0
    t.integer "break_sack_rating", default: 0
    t.integer "break_tackle_rating", default: 0
    t.integer "carry_rating", default: 0
    t.integer "catch_rating", default: 0
    t.integer "c_it_rating", default: 0
    t.integer "throw_acc_deep_rating", default: 0
    t.integer "route_run_deep_rating", default: 0
    t.integer "elusive_rating", default: 0
    t.integer "finesse_moves_rating", default: 0
    t.integer "hit_power_rating", default: 0
    t.integer "impact_block_rating", default: 0
    t.integer "injury_rating", default: 0
    t.integer "juke_move_rating", default: 0
    t.integer "jump_rating", default: 0
    t.integer "kick_acc_rating", default: 0
    t.integer "kick_power_rating", default: 0
    t.integer "kick_ret_rating", default: 0
    t.integer "lead_block_rating", default: 0
    t.integer "man_cover_rating", default: 0
    t.integer "throw_acc_mid_rating", default: 0
    t.integer "route_run_med_rating", default: 0
    t.integer "pass_block_rating", default: 0
    t.integer "pass_block_finesse_rating", default: 0
    t.integer "pass_block_power_rating", default: 0
    t.integer "play_action_rating", default: 0
    t.integer "play_rec_rating", default: 0
    t.integer "power_moves_rating", default: 0
    t.integer "press_rating", default: 0
    t.integer "pursuit_rating", default: 0
    t.integer "release_rating", default: 0
    t.integer "run_block_rating", default: 0
    t.integer "run_block_finesse_rating", default: 0
    t.integer "run_block_power_rating", default: 0
    t.integer "throw_acc_short_rating", default: 0
    t.integer "route_run_short_rating", default: 0
    t.integer "spec_catch_rating", default: 0
    t.integer "speed_rating", default: 0
    t.integer "spin_move_rating", default: 0
    t.integer "stamina_rating", default: 0
    t.integer "stiff_arm_rating", default: 0
    t.integer "strength_rating", default: 0
    t.integer "tackle_rating", default: 0
    t.integer "throw_on_run_rating", default: 0
    t.integer "throw_power_rating", default: 0
    t.integer "throw_under_pressure_rating", default: 0
    t.integer "tough_rating", default: 0
    t.integer "truck_rating", default: 0
    t.integer "zone_cover_rating", default: 0
  end

  create_table "dev_traits", id: :integer, default: nil, force: :cascade do |t|
    t.decimal "rating"
  end

  create_table "draft_positions", id: :integer, default: nil, force: :cascade do |t|
    t.decimal "rating"
  end

  create_table "leagues", id: :bigint, default: nil, force: :cascade do |t|
    t.string "name"
  end

  create_table "overalls", id: :integer, default: nil, force: :cascade do |t|
    t.decimal "rating"
  end

  create_table "player_archetypes", id: :string, force: :cascade do |t|
    t.bigint "player_id"
    t.integer "archetype_id"
    t.integer "overall"
    t.decimal "rating"
  end

  create_table "players", id: :string, force: :cascade do |t|
    t.bigint "league_id"
    t.bigint "player_id"
    t.bigint "team_id"
    t.integer "age"
    t.integer "birth_day"
    t.integer "birth_month"
    t.integer "birth_year"
    t.integer "contract_years_left"
    t.integer "contract_length"
    t.integer "draft_pick"
    t.integer "draft_round"
    t.integer "height"
    t.integer "home_state"
    t.integer "injury_length"
    t.integer "injury_type"
    t.integer "jersey_num"
    t.integer "legacy_score"
    t.integer "skill_points"
    t.integer "rookie_year"
    t.integer "run_style"
    t.integer "re_sign_status"
    t.integer "weight"
    t.integer "experience_points"
    t.integer "years_pro"
    t.integer "player_best_ovr"
    t.integer "player_scheme_ovr"
    t.integer "scheme"
    t.integer "team_scheme_ovr"
    t.integer "durability_grade"
    t.integer "intangible_grade"
    t.integer "physical_grade"
    t.integer "production_grade"
    t.integer "size_grade"
    t.integer "accel_rating"
    t.integer "agility_rating"
    t.integer "aware_rating"
    t.integer "b_cv_rating"
    t.integer "block_shed_rating"
    t.integer "break_sack_rating"
    t.integer "break_tackle_rating"
    t.integer "conf_rating"
    t.integer "carry_rating"
    t.integer "catch_rating"
    t.integer "c_it_rating"
    t.integer "elusive_rating"
    t.integer "finesse_moves_rating"
    t.integer "hit_power_rating"
    t.integer "impact_block_rating"
    t.integer "injury_rating"
    t.integer "juke_move_rating"
    t.integer "jump_rating"
    t.integer "kick_acc_rating"
    t.integer "kick_power_rating"
    t.integer "kick_ret_rating"
    t.integer "lead_block_rating"
    t.integer "man_cover_rating"
    t.integer "pass_block_finesse_rating"
    t.integer "pass_block_power_rating"
    t.integer "play_action_rating"
    t.integer "play_rec_rating"
    t.integer "press_rating"
    t.integer "pursuit_rating"
    t.integer "pass_block_rating"
    t.integer "power_moves_rating"
    t.integer "run_block_finesse_rating"
    t.integer "run_block_power_rating"
    t.integer "release_rating"
    t.integer "run_block_rating"
    t.integer "route_run_deep_rating"
    t.integer "route_run_med_rating"
    t.integer "route_run_short_rating"
    t.integer "spec_catch_rating"
    t.integer "speed_rating"
    t.integer "spin_move_rating"
    t.integer "stiff_arm_rating"
    t.integer "stamina_rating"
    t.integer "strength_rating"
    t.integer "tackle_rating"
    t.integer "tough_rating"
    t.integer "throw_acc_rating"
    t.integer "throw_acc_deep_rating"
    t.integer "throw_acc_mid_rating"
    t.integer "throw_acc_short_rating"
    t.integer "throw_power_rating"
    t.integer "throw_on_run_rating"
    t.integer "throw_under_pressure_rating"
    t.integer "truck_rating"
    t.integer "zone_cover_rating"
    t.integer "big_hit_trait"
    t.integer "clutch_trait"
    t.integer "cover_ball_trait"
    t.integer "d_l_bull_rush_trait"
    t.integer "d_l_spin_trait"
    t.integer "d_l_swim_trait"
    t.integer "drop_open_pass_trait"
    t.integer "dev_trait"
    t.integer "fight_for_yards_trait"
    t.integer "force_pass_trait"
    t.integer "feet_in_bounds_trait"
    t.integer "high_motor_trait"
    t.integer "h_p_catch_trait"
    t.integer "l_b_style_trait"
    t.integer "play_ball_trait"
    t.integer "penalty_trait"
    t.integer "predict_trait"
    t.integer "pos_catch_trait"
    t.integer "q_b_style_trait"
    t.integer "sense_pressure_trait"
    t.integer "strip_ball_trait"
    t.integer "tight_spiral_trait"
    t.integer "throw_away_trait"
    t.integer "y_ac_catch_trait"
    t.money "cap_hit", scale: 2
    t.money "cap_release_net_savings", scale: 2
    t.money "cap_release_penalty", scale: 2
    t.money "contract_bonus", scale: 2
    t.money "contract_salary", scale: 2
    t.money "desired_bonus", scale: 2
    t.money "desired_salary", scale: 2
    t.integer "desired_length"
    t.string "college"
    t.string "first_name"
    t.string "home_town"
    t.string "last_name"
    t.string "position"
    t.boolean "is_active"
    t.boolean "is_free_agent"
    t.boolean "is_on_ir"
    t.boolean "is_on_practice_squad"
  end

  create_table "schedules", id: :string, force: :cascade do |t|
    t.bigint "league_id"
    t.bigint "schedule_id"
    t.bigint "away_team_id"
    t.bigint "home_team_id"
    t.integer "away_score"
    t.integer "home_score"
    t.integer "season_index"
    t.integer "stage_index"
    t.integer "status"
    t.integer "week_index"
    t.boolean "is_game_of_the_week"
  end

  create_table "scheme_archetypes", id: :integer, default: nil, force: :cascade do |t|
    t.integer "scheme_id"
    t.integer "archetype_id"
  end

  create_table "schemes", id: :integer, default: nil, force: :cascade do |t|
    t.string "name"
  end

  create_table "teams", id: :string, force: :cascade do |t|
    t.bigint "league_id"
    t.bigint "team_id"
    t.integer "def_scheme"
    t.integer "injury_count"
    t.integer "off_scheme"
    t.integer "ovr_rating"
    t.string "abbr_name"
    t.string "city_name"
    t.string "display_name"
    t.string "div_name"
    t.string "nick_name"
  end

end
