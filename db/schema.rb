# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_11_195942) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coaches", force: :cascade do |t|
    t.bigint "team_id"
    t.string "name"
    t.decimal "overall_rating"
    t.decimal "offense_rating"
    t.decimal "defense_rating"
    t.decimal "specialteams_rating"
  end

  create_table "games", id: :string, force: :cascade do |t|
    t.integer "season"
    t.integer "week"
    t.integer "slot"
    t.string "home_team"
    t.integer "home_rating"
    t.string "away_team"
    t.integer "away_rating"
    t.decimal "line"
  end

  create_table "player_archetypes", force: :cascade do |t|
    t.bigint "player_id"
    t.string "name"
    t.integer "overall_rating"
  end

  create_table "player_contracts", force: :cascade do |t|
    t.bigint "player_id"
    t.integer "contract_year"
    t.money "cap_hit", scale: 2
    t.money "salary", scale: 2
    t.money "bonus", scale: 2
  end

  create_table "players", force: :cascade do |t|
    t.bigint "team_id"
    t.string "name"
    t.string "position"
    t.string "role"
    t.string "style"
    t.string "development_trait"
    t.string "contract_status"
    t.string "injury_status"
    t.integer "age"
    t.integer "draft_round"
    t.integer "draft_pick"
    t.integer "year_drafted"
    t.integer "years_pro"
    t.integer "contract_length"
    t.integer "contract_year"
    t.integer "contract_years_left"
    t.integer "overall_rating"
    t.integer "rating"
    t.decimal "value"
    t.money "cap_hit", scale: 2
    t.money "cap_savings", scale: 2
    t.money "cap_penalty", scale: 2
  end

  create_table "prospect_archetypes", force: :cascade do |t|
    t.bigint "prospect_id"
    t.integer "rating"
    t.string "name"
    t.string "grade"
  end

  create_table "prospects", force: :cascade do |t|
    t.string "name"
    t.string "position"
    t.string "role"
    t.string "style"
    t.string "development_trait"
    t.string "grade"
    t.integer "age"
    t.integer "draft_round"
    t.integer "draft_pick"
    t.decimal "value"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "conference"
    t.string "division"
    t.decimal "overall_rating"
    t.decimal "offense_rating"
    t.decimal "defense_rating"
    t.decimal "specialteams_rating"
    t.decimal "passing_rating"
    t.decimal "rushing_rating"
    t.decimal "receiving_rating"
    t.decimal "passrush_rating"
    t.decimal "rundefense_rating"
    t.decimal "passcoverage_rating"
  end

end
