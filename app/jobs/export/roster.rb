class Export::Roster < ApplicationJob
  VALUES = [0.95, ([0.7] * 4), ([0.55] * 11), ([0.45] * 11), ([0.3] * 4), 0.05].flatten.map(&:to_d).freeze


  def perform
    generate_fantasy_draft
    nil
  end


  private

  def generate_fantasy_draft
    teams = {"Bears"=>0, "Bengals"=>0, "Bills"=>0, "Broncos"=>0, "Browns"=>0, "Buccaneers"=>0, "Cardinals"=>0, "Chargers"=>0, "Chiefs"=>0, "Colts"=>0, "Cowboys"=>0, "Dolphins"=>0, "Eagles"=>0, "Falcons"=>0, "49ers"=>0, "Giants"=>0, "Jaguars"=>0, "Jets"=>0, "Lions"=>0, "Packers"=>0, "Panthers"=>0, "Patriots"=>0, "Raiders"=>0, "Rams"=>0, "Ravens"=>0, "Redskins"=>0, "Saints"=>0, "Seahawks"=>0, "Steelers"=>0, "Titans"=>0, "Vikings"=>0, "Texans"=>0}
    players = []

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
        player = rnd_players[index]

        players << {
          name: player.name,
          role: player.role,
          age: player.age,
          rating: player.rating,
          team_id: (teams.keys.index(team_name) + 1)
        }
      end
    end

    assign_players(players)
  end

  def assign_players(players, data = [])
    CSV.foreach(Rails.root.join("roster.csv"), headers: true, header_converters: :symbol) do |row|
      player = nil

      players.each do |plyr|
        if plyr[:name] == [row[:pfna], row[:plna]].compact.join(" ") && plyr[:age].to_i == row[:page].to_i
          player = plyr
          break
        end
      end

      if player.nil?
        row[:tgid] = 1009
        row[:pcon], row[:pcyl], row[:pcsa], row[:ptsa], row[:psbo] = 0, 0, 0, 0, 0
        row[:psa0], row[:psa1], row[:psa2], row[:psa3], row[:psa4], row[:psa5], row[:psa6] = 0, 0, 0, 0, 0, 0, 0
        row[:psb0], row[:psb1], row[:psb2], row[:psb3], row[:psb4], row[:psb5], row[:psb6] = 0, 0, 0, 0, 0, 0, 0
      else
        row[:tgid] = player[:team_id]

        if row[:pyrp].to_i >= 4 # :NOTE: Only calculate contracts for players not on 'Rookie Deal'
          contract = calculate_contract(player[:role], player[:rating])

          row[:ptsa] = (row[:pcon].to_i * contract[:cap_hit])   # total cap hit
          row[:psbo] = (row[:pcon].to_i * contract[:bonus])     # total bonus
          row[:pcsa] = contract[:cap_hit]                       # current cap hit

          row[:psa0] = contract[:salary] if row[:pcon].to_i >= 1
          row[:psa1] = contract[:salary] if row[:pcon].to_i >= 2
          row[:psa2] = contract[:salary] if row[:pcon].to_i >= 3
          row[:psa3] = contract[:salary] if row[:pcon].to_i >= 4
          row[:psa4] = contract[:salary] if row[:pcon].to_i >= 5
          row[:psa5] = contract[:salary] if row[:pcon].to_i >= 6
          row[:psa6] = contract[:salary] if row[:pcon].to_i >= 7

          row[:psb0] = contract[:bonus] if row[:pcon].to_i >= 1
          row[:psb1] = contract[:bonus] if row[:pcon].to_i >= 2
          row[:psb2] = contract[:bonus] if row[:pcon].to_i >= 3
          row[:psb3] = contract[:bonus] if row[:pcon].to_i >= 4
          row[:psb4] = contract[:bonus] if row[:pcon].to_i >= 5
          row[:psb5] = contract[:bonus] if row[:pcon].to_i >= 6
          row[:psb6] = contract[:bonus] if row[:pcon].to_i >= 7
        end
      end

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
      Player.where(role: "QB").order(value: :desc, age: :asc, name: :asc).limit(32)
    when 2 # QB2
      Player.where(role: "QB").order(value: :desc, age: :asc, name: :asc).limit(32).offset(32)
    when 3 # HB1
      Player.where(role: "HB").order(value: :desc, age: :asc, name: :asc).limit(32)
    when 4 # HB2
      Player.where(role: "HB").order(value: :desc, age: :asc, name: :asc).limit(32).offset(32)
    when 5 # HB3
      Player.where(role: "HB").order(value: :desc, age: :asc, name: :asc).limit(32).offset(64)
    when 6 # HB4
      Player.where(role: "HB").order(value: :desc, age: :asc, name: :asc).limit(32).offset(96)
    when 7 # WR1
      Player.where(role: "WR").order(value: :desc, age: :asc, name: :asc).limit(32)
    when 8 # WR2
      Player.where(role: "WR").order(value: :desc, age: :asc, name: :asc).limit(32).offset(32)
    when 9 # WR3
      Player.where(role: "WR").order(value: :desc, age: :asc, name: :asc).limit(32).offset(64)
    when 10 # WR4
      Player.where(role: "WR").order(value: :desc, age: :asc, name: :asc).limit(32).offset(96)
    when 11 # WR5
      Player.where(role: "WR").order(value: :desc, age: :asc, name: :asc).limit(32).offset(128)
    when 12 # WR6
      Player.where(role: "WR").order(value: :desc, age: :asc, name: :asc).limit(32).offset(160)
    when 13 # TE1
      Player.where(role: "TE").order(value: :desc, age: :asc, name: :asc).limit(32)
    when 14 # TE2
      Player.where(role: "TE").order(value: :desc, age: :asc, name: :asc).limit(32).offset(32)
    when 15 # TE3
      Player.where(role: "TE").order(value: :desc, age: :asc, name: :asc).limit(32).offset(64)
    when 16 # TE4
      Player.where(role: "TE").order(value: :desc, age: :asc, name: :asc).limit(32).offset(96)
    when 17 # OT1
      Player.where(role: "OT").order(value: :desc, age: :asc, name: :asc).limit(32)
    when 18 # OT2
      Player.where(role: "OT").order(value: :desc, age: :asc, name: :asc).limit(32).offset(32)
    when 19 # OT3
      Player.where(role: "OT").order(value: :desc, age: :asc, name: :asc).limit(32).offset(64)
    when 20 # OT4
      Player.where(role: "OT").order(value: :desc, age: :asc, name: :asc).limit(32).offset(96)
    when 21 # IOL1
      Player.where(role: "IOL").order(value: :desc, age: :asc, name: :asc).limit(32)
    when 22 # IOL2
      Player.where(role: "IOL").order(value: :desc, age: :asc, name: :asc).limit(32).offset(32)
    when 23 # IOL3
      Player.where(role: "IOL").order(value: :desc, age: :asc, name: :asc).limit(32).offset(64)
    when 24 # IOL4
      Player.where(role: "IOL").order(value: :desc, age: :asc, name: :asc).limit(32).offset(96)
    when 25 # IOL5
      Player.where(role: "IOL").order(value: :desc, age: :asc, name: :asc).limit(32).offset(128)
    when 26 # IOL6
      Player.where(role: "IOL").order(value: :desc, age: :asc, name: :asc).limit(32).offset(160)
    when 27 # EDGE1
      Player.where(role: "ED").order(value: :desc, age: :asc, name: :asc).limit(32)
    when 28 # EDGE2
      Player.where(role: "ED").order(value: :desc, age: :asc, name: :asc).limit(32).offset(32)
    when 29 # EDGE3
      Player.where(role: "ED").order(value: :desc, age: :asc, name: :asc).limit(32).offset(64)
    when 30 # EDGE4
      Player.where(role: "ED").order(value: :desc, age: :asc, name: :asc).limit(32).offset(96)
    when 31 # IDL1
      Player.where(role: "IDL").order(value: :desc, age: :asc, name: :asc).limit(32)
    when 32 # IDL2
      Player.where(role: "IDL").order(value: :desc, age: :asc, name: :asc).limit(32).offset(32)
    when 33 # IDL3
      Player.where(role: "IDL").order(value: :desc, age: :asc, name: :asc).limit(32).offset(64)
    when 34 # IDL4
      Player.where(role: "IDL").order(value: :desc, age: :asc, name: :asc).limit(32).offset(96)
    when 35 # IDL5
      Player.where(role: "IDL").order(value: :desc, age: :asc, name: :asc).limit(32).offset(128)
    when 36 # IDL6
      Player.where(role: "IDL").order(value: :desc, age: :asc, name: :asc).limit(32).offset(160)
    when 37 # LB1
      Player.where(role: "LB").order(value: :desc, age: :asc, name: :asc).limit(32)
    when 38 # LB2
      Player.where(role: "LB").order(value: :desc, age: :asc, name: :asc).limit(32).offset(32)
    when 39 # LB3
      Player.where(role: "LB").order(value: :desc, age: :asc, name: :asc).limit(32).offset(64)
    when 40 # LB4
      Player.where(role: "LB").order(value: :desc, age: :asc, name: :asc).limit(32).offset(96)
    when 41 # CB1
      Player.where(role: "CB").order(value: :desc, age: :asc, name: :asc).limit(32)
    when 42 # CB2
      Player.where(role: "CB").order(value: :desc, age: :asc, name: :asc).limit(32).offset(32)
    when 43 # CB3
      Player.where(role: "CB").order(value: :desc, age: :asc, name: :asc).limit(32).offset(64)
    when 44 # CB4
      Player.where(role: "CB").order(value: :desc, age: :asc, name: :asc).limit(32).offset(96)
    when 45 # CB5
      Player.where(role: "CB").order(value: :desc, age: :asc, name: :asc).limit(32).offset(128)
    when 46 # CB6
      Player.where(role: "CB").order(value: :desc, age: :asc, name: :asc).limit(32).offset(160)
    when 47 # S1
      Player.where(role: "S").order(value: :desc, age: :asc, name: :asc).limit(32)
    when 48 # S2
      Player.where(role: "S").order(value: :desc, age: :asc, name: :asc).limit(32).offset(32)
    when 49 # S3
      Player.where(role: "S").order(value: :desc, age: :asc, name: :asc).limit(32).offset(64)
    when 50 # S4
      Player.where(role: "S").order(value: :desc, age: :asc, name: :asc).limit(32).offset(96)
    when 51 # K1
      Player.where(role: "K").order(value: :desc, age: :asc, name: :asc).limit(32)
    when 52 # P1
      Player.where(role: "K").order(value: :desc, age: :asc, name: :asc).limit(32).offset(32)
    end
  end

  def calculate_contract(role, rating)
    values = {
      "QB"=>{max: 4000, min: 1000},
      "HB"=>{max: 1400, min: 200},
      "WR"=>{max: 2500, min: 400},
      "TE"=>{max: 1500, min: 300},
      "OT"=>{max: 2200, min: 400},
      "IOL"=>{max: 1800, min: 300},
      "ED"=>{max: 2400, min: 300},
      "IDL"=>{max: 2000, min: 300},
      "LB"=>{max: 1800, min: 300},
      "CB"=>{max: 2100, min: 300},
      "S"=>{max: 1500, min: 300},
      "K"=>{max: 700, min: 100},
    }[role]

    cap_hit = if rating >= 70
      (((values[:max].to_d - values[:min].to_d) / 29.to_d) * (rating - 70)).round + values[:min].to_d
    elsif rating >= 60
      (((values[:min].to_d - 50.to_d) / 10.to_d) * (rating - 60)).round + 50.to_d
    else
      45.to_d
    end

    if rating >= 95
      salary = (cap_hit * 0.5.to_d).round.to_i
      {cap_hit: cap_hit.to_i, salary: salary, bonus: (cap_hit.to_i - salary)}
    elsif rating >= 90
      salary = (cap_hit * 0.6.to_d).round.to_i
      {cap_hit: cap_hit.to_i, salary: salary, bonus: (cap_hit.to_i - salary)}
    elsif rating >= 85
      salary = (cap_hit * 0.7.to_d).round.to_i
      {cap_hit: cap_hit.to_i, salary: salary, bonus: (cap_hit.to_i - salary)}
    elsif rating >= 80
      salary = (cap_hit * 0.8.to_d).round.to_i
      {cap_hit: cap_hit.to_i, salary: salary, bonus: (cap_hit.to_i - salary)}
    elsif rating >= 70
      salary = (cap_hit * 0.9.to_d).round.to_i
      {cap_hit: cap_hit.to_i, salary: salary, bonus: (cap_hit.to_i - salary)}
    else
      {cap_hit: cap_hit.to_i, salary: cap_hit.to_i, bonus: 0}
    end
  end
end
