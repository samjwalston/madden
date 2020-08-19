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

ActiveRecord::Schema.define(version: 20200819150934) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "archetypes", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "player_id"
    t.string "name"
    t.integer "overall_rating"
  end

  create_table "coaches", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "team_id"
    t.string "name"
    t.decimal "overall_rating"
    t.decimal "offense_rating"
    t.decimal "defense_rating"
    t.decimal "specialteams_rating"
  end

  create_table "contracts", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "player_id"
    t.integer "contract_year"
    t.money "salary", scale: 2
    t.money "bonus", scale: 2
  end

  create_table "grades", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "prospect_id"
    t.string "archetype"
    t.string "letter"
    t.integer "rating"
  end

  create_table "players", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "team_id"
    t.string "name"
    t.string "position"
    t.string "development_trait"
    t.string "status"
    t.integer "age"
    t.integer "overall_rating"
    t.integer "draft_round"
    t.integer "draft_pick"
    t.integer "year_drafted"
    t.integer "years_pro"
    t.integer "contract_length"
    t.integer "contract_year"
    t.integer "contract_years_left"
    t.money "cap_hit", scale: 2
    t.money "cap_savings", scale: 2
    t.money "cap_penalty", scale: 2
  end

  create_table "prospects", id: :bigint, default: nil, force: :cascade do |t|
    t.string "name"
    t.string "position"
    t.string "role"
    t.string "style"
    t.string "grade"
    t.string "development_trait"
    t.integer "age"
    t.integer "draft_round"
    t.integer "draft_pick"
    t.decimal "value"
  end

  create_table "roles", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "player_id"
    t.string "name"
    t.string "style"
    t.integer "rating"
    t.decimal "value"
  end

  create_table "teams", id: :bigint, default: nil, force: :cascade do |t|
    t.string "name"
    t.string "conference"
    t.string "division"
    t.decimal "overall_rating"
    t.decimal "offense_rating"
    t.decimal "defense_rating"
    t.decimal "specialteams_rating"
    t.decimal "quarterback_rating"
    t.decimal "rushing_rating"
    t.decimal "receiver_rating"
    t.decimal "passprotect_rating"
    t.decimal "passrush_rating"
    t.decimal "rundefense_rating"
    t.decimal "passcoverage_rating"
  end

end
