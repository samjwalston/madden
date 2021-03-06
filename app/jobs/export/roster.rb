class Export::Roster < ApplicationJob
  VALUES = [0.95, ([0.7] * 4), ([0.55] * 11), ([0.45] * 11), ([0.3] * 4), 0.05].flatten.map(&:to_d).freeze


  def perform
    generate_fantasy_draft
    nil
  end


  private

  def generate_fantasy_draft
    teams = {"Bears"=>0, "Bengals"=>0, "Bills"=>0, "Broncos"=>0, "Browns"=>0, "Buccaneers"=>0, "Cardinals"=>0, "Chargers"=>0, "Chiefs"=>0, "Colts"=>0, "Cowboys"=>0, "Dolphins"=>0, "Eagles"=>0, "Falcons"=>0, "49ers"=>0, "Giants"=>0, "Jaguars"=>0, "Jets"=>0, "Lions"=>0, "Packers"=>0, "Panthers"=>0, "Patriots"=>0, "Raiders"=>0, "Rams"=>0, "Ravens"=>0, "Redskins"=>0, "Saints"=>0, "Seahawks"=>0, "Steelers"=>0, "Titans"=>0, "Vikings"=>0, "Texans"=>0}
    players = {}

    (1..52).to_a.each do |rnd|
      rnd_players = get_players(rnd).to_a
      max = (rnd == 1 ? VALUES.first : (rnd * 0.75.to_d).round(2).to_f)
      min = (rnd == 1 ? VALUES.last : (rnd * 0.25.to_d).round(2).to_f)
      incorrect = true
      team_ids = []

      while incorrect
        team_ids = teams.keys.shuffle
        incorrect = false

        team_ids.each_with_index do |team_name, index|
          value = (teams[team_name].to_d + VALUES[index]).to_f

          if value > max || value < min
            incorrect = true
            break
          end
        end
      end

      team_ids.each_with_index do |team_name, index|
        teams[team_name] = (teams[team_name].to_d + VALUES[index]).to_f
        players[rnd_players[index].player.name] = (teams.keys.index(team_name) + 1)
      end
    end

    assign_players(players)
  end

  def assign_players(players, data = [])
    puts players

    CSV.foreach(Rails.root.join("roster.csv"), {headers: true, header_converters: :symbol}) do |row|
      name = [row[:pfna], row[:plna]].compact.join(" ")
      team_id = players[[row[:pfna], row[:plna]].compact.join(" ")]

      row[:tgid] = team_id.nil? ? 1009 : team_id

      data << row.to_h.values
    end

    CSV.open(Rails.root.join("roster_new.csv"), "wb") do |row|
      data.each do |info|
        row << info
      end
    end
  end

  def get_players(rnd)
    case rnd
    when 1 # QB1
      Role.includes(:player).where(name: "QB").order("roles.value desc", "players.age", "players.name").limit(32)
    when 2 # QB2
      Role.includes(:player).where(name: "QB").order("roles.value desc", "players.age", "players.name").limit(32).offset(32)
    when 3 # HB1
      Role.includes(:player).where(name: "HB").order("roles.value desc", "players.age", "players.name").limit(32)
    when 4 # HB2
      Role.includes(:player).where(name: "HB").order("roles.value desc", "players.age", "players.name").limit(32).offset(32)
    when 5 # HB3
      Role.includes(:player).where(name: "HB").order("roles.value desc", "players.age", "players.name").limit(32).offset(64)
    when 6 # HB4
      Role.includes(:player).where(name: "HB").order("roles.value desc", "players.age", "players.name").limit(32).offset(96)
    when 7 # WR1
      Role.includes(:player).where(name: "WR").order("roles.value desc", "players.age", "players.name").limit(32)
    when 8 # WR2
      Role.includes(:player).where(name: "WR").order("roles.value desc", "players.age", "players.name").limit(32).offset(32)
    when 9 # WR3
      Role.includes(:player).where(name: "WR").order("roles.value desc", "players.age", "players.name").limit(32).offset(64)
    when 10 # WR4
      Role.includes(:player).where(name: "WR").order("roles.value desc", "players.age", "players.name").limit(32).offset(96)
    when 11 # WR5
      Role.includes(:player).where(name: "WR").order("roles.value desc", "players.age", "players.name").limit(32).offset(128)
    when 12 # WR6
      Role.includes(:player).where(name: "WR").order("roles.value desc", "players.age", "players.name").limit(32).offset(160)
    when 13 # TE1
      Role.includes(:player).where(name: "TE").order("roles.value desc", "players.age", "players.name").limit(32)
    when 14 # TE2
      Role.includes(:player).where(name: "TE").order("roles.value desc", "players.age", "players.name").limit(32).offset(32)
    when 15 # TE3
      Role.includes(:player).where(name: "TE").order("roles.value desc", "players.age", "players.name").limit(32).offset(64)
    when 16 # TE4
      Role.includes(:player).where(name: "TE").order("roles.value desc", "players.age", "players.name").limit(32).offset(96)
    when 17 # OT1
      Role.includes(:player).where(name: "OT").order("roles.value desc", "players.age", "players.name").limit(32)
    when 18 # OT2
      Role.includes(:player).where(name: "OT").order("roles.value desc", "players.age", "players.name").limit(32).offset(32)
    when 19 # OT3
      Role.includes(:player).where(name: "OT").order("roles.value desc", "players.age", "players.name").limit(32).offset(64)
    when 20 # OT4
      Role.includes(:player).where(name: "OT").order("roles.value desc", "players.age", "players.name").limit(32).offset(96)
    when 21 # IOL1
      Role.includes(:player).where(name: "IOL").order("roles.value desc", "players.age", "players.name").limit(32)
    when 22 # IOL2
      Role.includes(:player).where(name: "IOL").order("roles.value desc", "players.age", "players.name").limit(32).offset(32)
    when 23 # IOL3
      Role.includes(:player).where(name: "IOL").order("roles.value desc", "players.age", "players.name").limit(32).offset(64)
    when 24 # IOL4
      Role.includes(:player).where(name: "IOL").order("roles.value desc", "players.age", "players.name").limit(32).offset(96)
    when 25 # IOL5
      Role.includes(:player).where(name: "IOL").order("roles.value desc", "players.age", "players.name").limit(32).offset(128)
    when 26 # IOL6
      Role.includes(:player).where(name: "IOL").order("roles.value desc", "players.age", "players.name").limit(32).offset(160)
    when 27 # EDGE1
      Role.includes(:player).where(name: "EDGE").order("roles.value desc", "players.age", "players.name").limit(32)
    when 28 # EDGE2
      Role.includes(:player).where(name: "EDGE").order("roles.value desc", "players.age", "players.name").limit(32).offset(32)
    when 29 # EDGE3
      Role.includes(:player).where(name: "EDGE").order("roles.value desc", "players.age", "players.name").limit(32).offset(64)
    when 30 # EDGE4
      Role.includes(:player).where(name: "EDGE").order("roles.value desc", "players.age", "players.name").limit(32).offset(96)
    when 31 # IDL1
      Role.includes(:player).where(name: "IDL").order("roles.value desc", "players.age", "players.name").limit(32)
    when 32 # IDL2
      Role.includes(:player).where(name: "IDL").order("roles.value desc", "players.age", "players.name").limit(32).offset(32)
    when 33 # IDL3
      Role.includes(:player).where(name: "IDL").order("roles.value desc", "players.age", "players.name").limit(32).offset(64)
    when 34 # IDL4
      Role.includes(:player).where(name: "IDL").order("roles.value desc", "players.age", "players.name").limit(32).offset(96)
    when 35 # IDL5
      Role.includes(:player).where(name: "IDL").order("roles.value desc", "players.age", "players.name").limit(32).offset(128)
    when 36 # IDL6
      Role.includes(:player).where(name: "IDL").order("roles.value desc", "players.age", "players.name").limit(32).offset(160)
    when 37 # LB1
      Role.includes(:player).where(name: "LB").order("roles.value desc", "players.age", "players.name").limit(32)
    when 38 # LB2
      Role.includes(:player).where(name: "LB").order("roles.value desc", "players.age", "players.name").limit(32).offset(32)
    when 39 # LB3
      Role.includes(:player).where(name: "LB").order("roles.value desc", "players.age", "players.name").limit(32).offset(64)
    when 40 # LB4
      Role.includes(:player).where(name: "LB").order("roles.value desc", "players.age", "players.name").limit(32).offset(96)
    when 41 # CB1
      Role.includes(:player).where(name: "CB").order("roles.value desc", "players.age", "players.name").limit(32)
    when 42 # CB2
      Role.includes(:player).where(name: "CB").order("roles.value desc", "players.age", "players.name").limit(32).offset(32)
    when 43 # CB3
      Role.includes(:player).where(name: "CB").order("roles.value desc", "players.age", "players.name").limit(32).offset(64)
    when 44 # CB4
      Role.includes(:player).where(name: "CB").order("roles.value desc", "players.age", "players.name").limit(32).offset(96)
    when 45 # CB5
      Role.includes(:player).where(name: "CB").order("roles.value desc", "players.age", "players.name").limit(32).offset(128)
    when 46 # CB6
      Role.includes(:player).where(name: "CB").order("roles.value desc", "players.age", "players.name").limit(32).offset(160)
    when 47 # S1
      Role.includes(:player).where(name: "S").order("roles.value desc", "players.age", "players.name").limit(32)
    when 48 # S2
      Role.includes(:player).where(name: "S").order("roles.value desc", "players.age", "players.name").limit(32).offset(32)
    when 49 # S3
      Role.includes(:player).where(name: "S").order("roles.value desc", "players.age", "players.name").limit(32).offset(64)
    when 50 # S4
      Role.includes(:player).where(name: "S").order("roles.value desc", "players.age", "players.name").limit(32).offset(96)
    when 51 # K1
      Role.includes(:player).where(name: "K").order("roles.value desc", "players.age", "players.name").limit(32)
    when 52 # P1
      Role.includes(:player).where(name: "P").order("roles.value desc", "players.age", "players.name").limit(32)
    end
  end
end
