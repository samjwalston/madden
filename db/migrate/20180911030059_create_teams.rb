class CreateTeams < ActiveRecord::Migration[5.1]
  def up
    create_table :teams, id: false do |t|
      t.bigint :id, primary_key: true
      t.integer :def_scheme
      t.integer :injury_count
      t.integer :off_scheme
      t.integer :ovr_rating
      t.string :abbr_name
      t.string :city_name
      t.string :display_name
      t.string :div_name
      t.string :nick_name
    end
  end

  def down
    drop_table :teams
  end
end
