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

ActiveRecord::Schema.define(version: 20200402232757) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "archetypes", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "player_id"
    t.string "name"
    t.integer "overall_rating"
  end

  create_table "contracts", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "player_id"
    t.integer "contract_year"
    t.money "salary", scale: 2
    t.money "bonus", scale: 2
  end

  create_table "players", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "team_id"
    t.string "name"
    t.string "first_name"
    t.string "last_name"
    t.string "position"
    t.string "development_trait"
    t.string "injury_status"
    t.integer "age"
    t.integer "overall_rating"
    t.integer "draft_round"
    t.integer "draft_pick"
    t.integer "year_drafted"
    t.integer "contract_length"
    t.integer "contract_year"
    t.integer "contract_years_left"
    t.money "cap_hit", scale: 2
    t.money "cap_savings", scale: 2
    t.money "cap_penalty", scale: 2
    t.boolean "is_injured_reserve"
  end

  create_table "teams", id: :bigint, default: nil, force: :cascade do |t|
    t.string "name"
    t.integer "ovrerall_rating"
    t.integer "offense_rating"
    t.integer "defense_rating"
    t.integer "specialteams_rating"
    t.integer "quaterback_rating"
    t.integer "runningback_rating"
    t.integer "widereceiver_rating"
    t.integer "tightend_rating"
    t.integer "offensiveline_rating"
    t.integer "defensiveline_rating"
    t.integer "linebacker_rating"
    t.integer "defensiveback_rating"
  end

end
