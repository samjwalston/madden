class CreateTeams < ActiveRecord::Migration[5.1]
  def up
    create_table :teams, id: false do |t|
      t.string :id, primary_key: true # "#{league_id}:#{team_id}"
      t.bigint :conference_id
      t.bigint :division_id
      t.bigint :league_id
      t.bigint :logo_id
      t.bigint :team_id
      t.integer :cap_available
      t.integer :cap_room
      t.integer :cap_spent
      t.integer :def_scheme
      t.integer :injury_count
      t.integer :off_scheme
      t.integer :ovr_rating
      t.integer :primary_color
      t.integer :secondary_color
      t.integer :team_ovr
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

    add_index :teams, [:league_id], name: :teams_league_index
    add_index :teams, [:team_id], name: :teams_identifier_index
  end

  def down
    drop_table :teams
  end
end
