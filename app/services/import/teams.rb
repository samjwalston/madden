class Import::Teams < ApplicationService
  require 'csv'

  def call
    ::Team.delete_all
    ::Team.create(values)

    nil
  end


  private

  def values
    records = []
    team_info = get_team_info

    CSV.foreach(Rails.root.join("teams.csv"), {headers: true, header_converters: :symbol}) do |row|
      next if row[:teamindex].to_i >= 32
      # next unless row[:displayname].in?(["Colts","Seahawks"])


      team_id = (row[:teamindex].to_i + 1)
      quarterback_rating = get_quarterback_rating(team_id)
      rushing_rating = get_rushing_rating(team_id)
      receiving_rating = get_receiving_rating(team_id)
      passprotect_rating = get_passprotect_rating(team_id)
      passrush_rating = get_passrush_rating(team_id)
      rundefense_rating = get_rundefense_rating(team_id)
      passcoverage_rating = get_passcoverage_rating(team_id)

      culture_rating = get_culture_rating(row)
      offense_rating = get_offense_rating(team_id, culture_rating, quarterback_rating, rushing_rating, receiving_rating, passprotect_rating)
      defense_rating = get_defense_rating(team_id, culture_rating, passrush_rating, rundefense_rating, passcoverage_rating)
      specialteams_rating = get_specialteams_rating(team_id, culture_rating)

      overall_rating = [
        offense_rating.to_d * 0.58.to_d,
        defense_rating.to_d * 0.38.to_d,
        specialteams_rating.to_d * 0.04.to_d,
      ].sum.round(2)


      records << {
        id: team_id,
        name: row[:displayname],
        conference: team_info[row[:displayname]]["Conference"],
        division: team_info[row[:displayname]]["Division"],
        overall_rating: overall_rating,
        offense_rating: offense_rating,
        defense_rating: defense_rating,
        specialteams_rating: specialteams_rating,
        quarterback_rating: quarterback_rating,
        rushing_rating: rushing_rating,
        receiver_rating: receiving_rating,
        passprotect_rating: passprotect_rating,
        passrush_rating: passrush_rating,
        rundefense_rating: rundefense_rating,
        passcoverage_rating: passcoverage_rating,
      }
    end

    records
  end

  def get_team_info
    {
      "Bears"=>{"Conference"=>"NFC", "Division"=>"North"},
      "Bengals"=>{"Conference"=>"AFC", "Division"=>"North"},
      "Bills"=>{"Conference"=>"AFC", "Division"=>"East"},
      "Broncos"=>{"Conference"=>"AFC", "Division"=>"West"},
      "Browns"=>{"Conference"=>"AFC", "Division"=>"North"},
      "Buccaneers"=>{"Conference"=>"NFC", "Division"=>"South"},
      "Cardinals"=>{"Conference"=>"NFC", "Division"=>"West"},
      "Chargers"=>{"Conference"=>"AFC", "Division"=>"West"},
      "Chiefs"=>{"Conference"=>"AFC", "Division"=>"West"},
      "Colts"=>{"Conference"=>"AFC", "Division"=>"South"},
      "Cowboys"=>{"Conference"=>"NFC", "Division"=>"East"},
      "Dolphins"=>{"Conference"=>"AFC", "Division"=>"East"},
      "Eagles"=>{"Conference"=>"NFC", "Division"=>"East"},
      "Falcons"=>{"Conference"=>"NFC", "Division"=>"South"},
      "49ers"=>{"Conference"=>"NFC", "Division"=>"West"},
      "Giants"=>{"Conference"=>"NFC", "Division"=>"East"},
      "Jaguars"=>{"Conference"=>"AFC", "Division"=>"South"},
      "Jets"=>{"Conference"=>"AFC", "Division"=>"East"},
      "Lions"=>{"Conference"=>"NFC", "Division"=>"North"},
      "Packers"=>{"Conference"=>"NFC", "Division"=>"North"},
      "Panthers"=>{"Conference"=>"NFC", "Division"=>"South"},
      "Patriots"=>{"Conference"=>"AFC", "Division"=>"East"},
      "Raiders"=>{"Conference"=>"AFC", "Division"=>"West"},
      "Rams"=>{"Conference"=>"NFC", "Division"=>"West"},
      "Ravens"=>{"Conference"=>"AFC", "Division"=>"North"},
      "Huskies"=>{"Conference"=>"NFC", "Division"=>"East"},
      "Saints"=>{"Conference"=>"NFC", "Division"=>"South"},
      "Seahawks"=>{"Conference"=>"NFC", "Division"=>"West"},
      "Steelers"=>{"Conference"=>"AFC", "Division"=>"North"},
      "Texans"=>{"Conference"=>"AFC", "Division"=>"South"},
      "Titans"=>{"Conference"=>"AFC", "Division"=>"South"},
      "Vikings"=>{"Conference"=>"NFC", "Division"=>"North"},
    }
  end

  def get_quarterback_rating(team_id)
    quarterback_depth = Player.includes(:role).where(team_id: team_id, position: "QB", injury_status: "Uninjured")
    quarterback = quarterback_depth.to_a.sort{|a, b| b.role.rating <=> a.role.rating}.first

    quarterback.role.rating.to_d rescue 0
  end

  def get_rushing_rating(team_id)
    runningback_depth = Player.includes(:archetypes, :role).where(team_id: team_id, position: "HB", injury_status: "Uninjured")
    interior_depth = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["LG", "C", "RG"], injury_status: "Uninjured")
    tackle_depth = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["LT", "RT"], injury_status: "Uninjured")
    blocker_depth = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["TE", "FB"], injury_status: "Uninjured")
    styles = []


    # HB Rushing Rating Calculations
    runningback_player = runningback_depth.dup.map do |player|
      {id: player.id, rating: player.archetypes.find_all{|a| a.name.in?(["Power Back", "Elusive Back"])}.sort{|a, b| b.overall_rating <=> a.overall_rating}.first.overall_rating}
    end.sort{|a, b| b[:rating] <=> a[:rating]}.first

    runningback = runningback_depth.detect{|p| p.id == runningback_player[:id]}

    runningback_rating = if runningback.role.style == "Balanced"
      (runningback_player[:rating].to_d * 1.05.to_d)
    else
      runningback_player[:rating].to_d
    end

    styles << (runningback.role.style == "Elusive" ? "Finesse" : runningback.role.style)


    # IOL Rushing Rating Calculations
    interior_players = interior_depth.dup.map do |player|
      {id: player.id, rating: player.archetypes.find_all{|a| a.name.in?(["Power", "Agile"])}.sort{|a, b| b.overall_rating <=> a.overall_rating}.first.overall_rating}
    end.sort{|a, b| b[:rating] <=> a[:rating]}[0..2]

    interior_rating = (interior_players.map do |interior_player|
      interior = interior_depth.detect{|p| p.id == interior_player[:id]}
      styles << interior.role.style

      if interior.role.style == "Balanced"
        (interior_player[:rating].to_d * 1.01.to_d)
      else
        interior_player[:rating].to_d
      end
    end.sum / 3.to_d)


    # OT Rushing Rating Calculations
    tackle_players = tackle_depth.dup.map do |player|
      {id: player.id, rating: player.archetypes.find_all{|a| a.name.in?(["Power", "Agile"])}.sort{|a, b| b.overall_rating <=> a.overall_rating}.first.overall_rating}
    end.sort{|a, b| b[:rating] <=> a[:rating]}[0..1]

    tackle_rating = (tackle_players.map do |tackle_player|
      tackle = tackle_depth.detect{|p| p.id == tackle_player[:id]}
      styles << tackle.role.style

      if tackle.role.style == "Balanced"
        (tackle_player[:rating].to_d * 1.01.to_d)
      else
        tackle_player[:rating].to_d
      end
    end.sum / 2.to_d)


    # TE/FB Rushing Rating Calculations
    blocker_player = blocker_depth.dup.map do |player|
      {id: player.id, rating: player.archetypes.detect{|a| a.name == "Blocking"}.overall_rating}
    end.sort{|a, b| b[:rating] <=> a[:rating]}.first

    blocker = blocker_depth.detect{|p| p.id == blocker_player[:id]}

    blocker_rating = if blocker.role.style == "Balanced"
      (blocker_player[:rating].to_d * 1.01.to_d)
    else
      blocker_player[:rating].to_d
    end


    # Final Rushing Rating Calculations
    rushing_rating = [
      runningback_rating * 0.25.to_d,
      interior_rating * 0.45.to_d,
      tackle_rating * 0.24.to_d,
      blocker_rating * 0.06.to_d
    ].sum

    if styles.uniq.size == 1
      (rushing_rating * 1.1.to_d).round(2)
    else
      rushing_rating.round(2)
    end
  end

  def get_receiving_rating(team_id)
    widereceiver_depth = Player.includes(:role).where(team_id: team_id, position: "WR", injury_status: "Uninjured")
    tightend_depth = Player.includes(:role).where(team_id: team_id, position: "TE", injury_status: "Uninjured")
    runningback_depth = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["HB", "FB"], injury_status: "Uninjured")
    styles = []


    # WR Receiving Rating Calculations
    widereceivers = widereceiver_depth.to_a.sort{|a, b| b.role.rating <=> a.role.rating}[0..2]

    widereceiver_rating = (widereceivers.map do |player|
      styles << player.role.style
      player.role.rating.to_d rescue 0
    end.sum / 3.to_d)


    # TE Receiving Rating Calculations
    tightend_player = tightend_depth.dup.map do |player|
      {id: player.id, rating: player.archetypes.find_all{|a| a.name.in?(["Vertical Threat", "Possession"])}.sort{|a, b| b.overall_rating <=> a.overall_rating}.first.overall_rating}
    end.sort{|a, b| b[:rating] <=> a[:rating]}.first

    tightend = tightend_depth.detect{|p| p.id == tightend_player[:id]}
    possession = tightend.archetypes.detect{|a| a.name == "Possession"}.overall_rating.to_d
    vertical = tightend.archetypes.detect{|a| a.name == "Vertical Threat"}.overall_rating.to_d
    tightend_player[:rating] = [possession * 0.5.to_d, vertical * 0.5.to_d].sum

    tightend_rating = if tightend.role.style == "Balanced"
      (tightend_player[:rating].to_d * 1.05.to_d)
    else
      tightend_player[:rating].to_d
    end


    # HB/FB Receiving Rating Calculations
    runningback_player = runningback_depth.dup.map do |player|
      {id: player.id, rating: player.archetypes.detect{|a| a.name.in?(["Receiving Back", "Utility"])}.overall_rating}
    end.sort{|a, b| b[:rating] <=> a[:rating]}.first

    runningback = runningback_depth.detect{|p| p.id == runningback_player[:id]}

    runningback_rating = if runningback.role.style == "Balanced"
      (runningback_player[:rating].to_d * 1.01.to_d)
    else
      runningback_player[:rating].to_d
    end


    # Final Receiving Rating Calculations
    receiving_rating = [
      widereceiver_rating * 0.78.to_d,
      tightend_rating * 0.18.to_d,
      runningback_rating * 0.04.to_d
    ].sum

    if styles.uniq.size == 3
      if styles.sort == ["Balanced", "Deep Threat", "Slot"]
        (receiving_rating * 1.1.to_d).round(2)
      else
        (receiving_rating * 1.05.to_d).round(2)
      end
    elsif styles.uniq.size == 2
      if styles.sort == ["Balanced", "Balanced", "Slot"]
        (receiving_rating * 1.1.to_d).round(2)
      else
        (receiving_rating * 1.025.to_d).round(2)
      end
    elsif styles.uniq.size == 1 && styles.first == "Balanced"
      (receiving_rating * 1.05.to_d).round(2)
    else
      receiving_rating.round(2)
    end
  end

  def get_passprotect_rating(team_id)
    tackle_depth = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["LT", "RT"], injury_status: "Uninjured")
    interior_depth = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["LG", "C", "RG"], injury_status: "Uninjured")
    blocker_depth = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["TE", "FB"], injury_status: "Uninjured")


    # OT Pass Protection Rating Calculations
    tackle_players = tackle_depth.dup.map do |player|
      {id: player.id, rating: player.archetypes.detect{|a| a.name == "Pass Protector"}.overall_rating}
    end.sort{|a, b| b[:rating] <=> a[:rating]}[0..1]

    tackle_rating = (tackle_players.map do |tackle_player|
      tackle = tackle_depth.detect{|p| p.id == tackle_player[:id]}

      if tackle.role.style == "Balanced"
        (tackle_player[:rating].to_d * 1.01.to_d)
      else
        tackle_player[:rating].to_d
      end
    end.sum / 2.to_d)


    # IOL Pass Protection Rating Calculations
    interior_players = interior_depth.dup.map do |player|
      {id: player.id, rating: player.archetypes.detect{|a| a.name == "Pass Protector"}.overall_rating}
    end.sort{|a, b| b[:rating] <=> a[:rating]}[0..2]

    interior_rating = (interior_players.map do |interior_player|
      interior = interior_depth.detect{|p| p.id == interior_player[:id]}

      if interior.role.style == "Balanced"
        (interior_player[:rating].to_d * 1.01.to_d)
      else
        interior_player[:rating].to_d
      end
    end.sum / 3.to_d)


    # TE/FB Pass Protection Rating Calculations
    blocker_player = blocker_depth.dup.map do |player|
      {id: player.id, rating: player.archetypes.detect{|a| a.name == "Blocking"}.overall_rating}
    end.sort{|a, b| b[:rating] <=> a[:rating]}.first

    blocker = blocker_depth.detect{|p| p.id == blocker_player[:id]}

    blocker_rating = if blocker.role.style == "Balanced"
      (blocker_player[:rating].to_d * 1.01.to_d)
    else
      blocker_player[:rating].to_d
    end


    # Final Pass Protection Rating Calculations
    [
      tackle_rating * 0.56.to_d,
      interior_rating * 0.42.to_d,
      blocker_rating * 0.02.to_d
    ].sum.round(2)
  end

  def get_passrush_rating(team_id)
    passrush_depth = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["DT", "LE", "RE", "LOLB", "ROLB"], injury_status: "Uninjured")
    edge_styles = []


    # EDGE Pass Rushing Rating Calculations
    edge_players = passrush_depth.dup.map do |player|
      player.role.name == "EDGE" ? {id: player.id, rating: player.role.rating} : nil
    end.compact.sort{|a, b| b[:rating] <=> a[:rating]}[0..1]

    edge_rating = (edge_players.map do |edge_player|
      edge = passrush_depth.detect{|p| p.id == edge_player[:id]}
      edge_styles << edge.role.style

      if edge.role.style == "Balanced"
        (edge_player[:rating].to_d * 1.05.to_d)
      else
        edge_player[:rating].to_d
      end
    end.sum / 2.to_d)


    # IDL Pass Rushing Rating Calculations
    interior_players = passrush_depth.dup.map do |player|
      if player.role.name == "IDL"
        power = player.archetypes.detect{|a| a.name == "Power Rusher"}.overall_rating.to_d
        speed = player.archetypes.detect{|a| a.name == "Speed Rusher"}.overall_rating.to_d
        rating = if speed > power
          [speed * 0.5.to_d, power * 0.5.to_d].sum
        else
          [power * 0.9.to_d, speed * 0.1.to_d].sum
        end

        {id: player.id, rating: rating}
      else
        nil
      end
    end.compact.sort{|a, b| b[:rating] <=> a[:rating]}[0..1]

    interior_rating = (interior_players.map do |interior_player|
      interior = passrush_depth.detect{|p| p.id == interior_player[:id]}

      if interior.role.style == "Balanced"
        (interior_player[:rating].to_d * 1.01.to_d)
      else
        interior_player[:rating].to_d
      end
    end.sum / 2.to_d)


    # Final Pass Rushing Rating Calculations
    passrush_rating = [
      edge_rating * 0.66.to_d,
      interior_rating * 0.34.to_d
    ].sum

    if edge_styles.uniq.size == 1 && edge_styles.first == "Balanced"
      (passrush_rating * 1.1.to_d).round(2)
    elsif edge_styles.uniq.sort == ["Power", "Speed"]
      (passrush_rating * 1.05.to_d).round(2)
    else
      passrush_rating.round(2)
    end
  end

  def get_rundefense_rating(team_id)
    defensiveline_depth = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["DT", "LE", "RE", "LOLB", "ROLB"], injury_status: "Uninjured")
    linebacker_depth = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["LOLB", "MLB", "ROLB"], injury_status: "Uninjured")
    safety_depth = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["FS", "SS"], injury_status: "Uninjured")


    # IDL Run Defense Rating Calculations
    interior_players = defensiveline_depth.dup.map do |player|
      if player.role.name == "IDL"
        {id: player.id, rating: player.archetypes.detect{|a| a.name == "Run Stopper"}.overall_rating}
      else
        nil
      end
    end.compact.sort{|a, b| b[:rating] <=> a[:rating]}[0..1]

    interior_rating = (interior_players.map do |interior_player|
      interior = defensiveline_depth.detect{|p| p.id == interior_player[:id]}

      if interior.role.style == "Balanced"
        (interior_player[:rating].to_d * 1.01.to_d)
      else
        interior_player[:rating].to_d
      end
    end.sum / 2.to_d)


    # EDGE Run Defense Rating Calculations
    edge_players = defensiveline_depth.dup.map do |player|
      if player.role.name == "EDGE"
        {id: player.id, rating: player.archetypes.detect{|a| a.name == "Run Stopper"}.overall_rating}
      else
        nil
      end
    end.compact.sort{|a, b| b[:rating] <=> a[:rating]}[0..1]

    edge_rating = (edge_players.map do |edge_player|
      edge = defensiveline_depth.detect{|p| p.id == edge_player[:id]}

      if edge.role.style == "Balanced"
        (edge_player[:rating].to_d * 1.01.to_d)
      else
        edge_player[:rating].to_d
      end
    end.sum / 2.to_d)


    # LB Run Defense Rating Calculations
    linebacker_players = linebacker_depth.dup.map do |player|
      if player.role.name == "LB"
        {id: player.id, rating: player.archetypes.detect{|a| a.name == "Run Stopper"}.overall_rating}
      else
        nil
      end
    end.compact.sort{|a, b| b[:rating] <=> a[:rating]}[0..1]

    linebacker_rating = (linebacker_players.map do |linebacker_player|
      linebacker = linebacker_depth.detect{|p| p.id == linebacker_player[:id]}

      if linebacker.role.style == "Balanced"
        (linebacker_player[:rating].to_d * 1.01.to_d)
      else
        linebacker_player[:rating].to_d
      end
    end.sum / 2.to_d)


    # S Run Defense Rating Calculations
    safety_player = safety_depth.dup.map do |player|
      {id: player.id, rating: player.archetypes.detect{|a| a.name == "Run Support"}.overall_rating}
    end.sort{|a, b| b[:rating] <=> a[:rating]}.first

    safety = safety_depth.detect{|p| p.id == safety_player[:id]}

    safety_rating = if safety.role.style == "Balanced"
      (safety_player[:rating].to_d * 1.01.to_d)
    else
      safety_player[:rating].to_d
    end


    # Final Run Defense Rating Calculations
    [
      interior_rating * 0.4.to_d,
      linebacker_rating * 0.32.to_d,
      edge_rating * 0.16.to_d,
      safety_rating * 0.12.to_d
    ].sum.round(2)
  end

  def get_passcoverage_rating(team_id)
    cornerback_depth = Player.includes(:role).where(team_id: team_id, position: "CB", injury_status: "Uninjured")
    safety_depth = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["FS", "SS"], injury_status: "Uninjured")
    linebacker_depth = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["MLB", "LOLB", "ROLB"], injury_status: "Uninjured")
    styles = []


    # CB Coverage Rating Calculations
    cornerback_players = cornerback_depth.to_a.sort{|a, b| b.role.rating <=> a.role.rating}[0..2]

    cornerback_rating = (cornerback_players.map do |player|
      styles << player.role.style
      player.role.rating.to_d rescue 0
    end.sum / 3.to_d)


    # S Coverage Rating Calculations
    safety_players = safety_depth.dup.map do |player|
      {id: player.id, rating: player.archetypes.detect{|a| a.name == "Zone"}.overall_rating}
    end.compact.sort{|a, b| b[:rating] <=> a[:rating]}[0..1]

    safety_rating = (safety_players.map do |safety_player|
      safety = safety_depth.detect{|p| p.id == safety_player[:id]}

      if safety.role.style == "Balanced"
        (safety_player[:rating].to_d * 1.01.to_d)
      else
        safety_player[:rating].to_d
      end
    end.sum / 2.to_d)


    # LB Coverage Rating Calculations
    linebacker_players = linebacker_depth.dup.map do |player|
      if player.role.name == "LB"
        {id: player.id, rating: player.archetypes.detect{|a| a.name == "Pass Coverage"}.overall_rating}
      else
        nil
      end
    end.compact.sort{|a, b| b[:rating] <=> a[:rating]}[0..1]

    linebacker_rating = (linebacker_players.map do |linebacker_player|
      linebacker = linebacker_depth.detect{|p| p.id == linebacker_player[:id]}

      if linebacker.role.style == "Balanced"
        (linebacker_player[:rating].to_d * 1.01.to_d)
      else
        linebacker_player[:rating].to_d
      end
    end.sum / 2.to_d)


    # Final Coverage Rating Calculations
    coverage_rating = [
      cornerback_rating * 0.55.to_d,
      safety_rating * 0.25.to_d,
      linebacker_rating * 0.2.to_d
    ].sum

    if styles.sort == ["Balanced", "Balanced", "Slot"]
      (coverage_rating * 1.1.to_d).round(2)
    elsif styles.sort == ["Man", "Man", "Slot"] || styles.sort == ["Zone", "Zone", "Slot"]
      (coverage_rating * 1.05.to_d).round(2)
    else
      coverage_rating.round(2)
    end
  end

  def get_culture_rating(team)
    grades = {"A+"=>97, "A"=>94, "A-"=>90, "B+"=>87, "B"=>84, "B-"=>80, "C+"=>77, "C"=>74, "C-"=>70, "D+"=>67, "D"=>64, "D-"=>60, "F+"=>57, "F"=>54, "F-"=>50}

    prestige_rating = grades[team[:prestigedisplay]].to_d
    reputation_rating = (team[:team_reputation].to_d / 100.to_d)
    history_rating = team[:teamhistory].to_d

    [
      prestige_rating * 0.5.to_d,
      reputation_rating * 0.35.to_d,
      history_rating * 0.15.to_d
    ].sum.round(2)
  end

  def get_offense_rating(team_id, culture_rating, quarterback_rating, rushing_rating, receiving_rating, passprotect_rating)
    coach = Coach.find_by(team_id: team_id)

    [
      coach.offense_rating.to_d * 0.1.to_d,
      culture_rating.to_d * 0.03.to_d,
      quarterback_rating.to_d * 0.38.to_d,
      rushing_rating.to_d * 0.12.to_d,
      receiving_rating.to_d * 0.23.to_d,
      passprotect_rating.to_d * 0.14.to_d
    ].sum.round(2)
  end

  def get_defense_rating(team_id, culture_rating, passrush_rating, rundefense_rating, passcoverage_rating)
    coach = Coach.find_by(team_id: team_id)

    [
      coach.defense_rating.to_d * 0.17.to_d,
      culture_rating.to_d * 0.03.to_d,
      passrush_rating.to_d * 0.24.to_d,
      rundefense_rating.to_d * 0.12.to_d,
      passcoverage_rating.to_d * 0.44.to_d,
    ].sum.round(2)
  end

  def get_specialteams_rating(team_id, culture_rating)
    coach = Coach.find_by(team_id: team_id)
    kicker_depth = Player.includes(:role).where(team_id: team_id, position: "K", injury_status: "Uninjured")
    punter_depth = Player.includes(:role).where(team_id: team_id, position: "P", injury_status: "Uninjured")


    # K Special Teams Rating Calculations
    kicker = kicker_depth.to_a.sort{|a, b| b.role.rating <=> a.role.rating}.first
    kicker_rating = kicker.role.rating.to_d rescue 0


    # P Special Teams Rating Calculations
    punter = punter_depth.to_a.sort{|a, b| b.role.rating <=> a.role.rating}.first
    punter_rating = punter.role.rating.to_d rescue 0


    # Final Special Teams Rating Calculations
    [
      coach.specialteams_rating.to_d * 0.47.to_d,
      culture_rating.to_d * 0.03.to_d,
      kicker_rating.to_d * 0.3.to_d,
      punter_rating.to_d * 0.2.to_d
    ].sum.round(2)
  end
end
