class Import::Teams < Import::Job
  def perform
    teams = get_values

    Team.delete_all
    Team.insert_all(teams)

    nil
  end


  private

  def get_values
    records = []
    team_info = get_team_info

    CSV.foreach(Rails.root.join("teams.csv"), headers: true, header_converters: :symbol) do |row|
      next if row[:teamindex].to_i >= 32


      team_id = (row[:teamindex].to_i + 1)
      passing_rating = get_passing_rating(team_id)
      rushing_rating = get_rushing_rating(team_id)
      receiving_rating = get_receiving_rating(team_id)
      passrush_rating = get_passrush_rating(team_id)
      rundefense_rating = get_rundefense_rating(team_id)
      passcoverage_rating = get_passcoverage_rating(team_id)

      offense_rating = get_offense_rating(team_id, passing_rating, rushing_rating, receiving_rating)
      defense_rating = get_defense_rating(team_id, passrush_rating, rundefense_rating, passcoverage_rating)
      specialteams_rating = get_specialteams_rating(team_id)

      overall_rating = [
        offense_rating.to_d * 0.58.to_d,
        defense_rating.to_d * 0.38.to_d,
        specialteams_rating.to_d * 0.04.to_d,
      ].sum


      records << {
        id: team_id,
        name: row[:displayname],
        conference: team_info[row[:displayname]]["Conference"],
        division: team_info[row[:displayname]]["Division"],
        overall_rating: overall_rating.round(2),
        offense_rating: offense_rating.round(2),
        defense_rating: defense_rating.round(2),
        specialteams_rating: specialteams_rating.round(2),
        passing_rating: passing_rating.round(2),
        rushing_rating: rushing_rating.round(2),
        receiving_rating: receiving_rating.round(2),
        passrush_rating: passrush_rating.round(2),
        rundefense_rating: rundefense_rating.round(2),
        passcoverage_rating: passcoverage_rating.round(2),
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
      "Redskins"=>{"Conference"=>"NFC", "Division"=>"East"},
      "Saints"=>{"Conference"=>"NFC", "Division"=>"South"},
      "Seahawks"=>{"Conference"=>"NFC", "Division"=>"West"},
      "Steelers"=>{"Conference"=>"AFC", "Division"=>"North"},
      "Texans"=>{"Conference"=>"AFC", "Division"=>"South"},
      "Titans"=>{"Conference"=>"AFC", "Division"=>"South"},
      "Vikings"=>{"Conference"=>"NFC", "Division"=>"North"},
    }
  end

  def get_players(team_id, *roles)
    Player.includes(:archetypes).where(team_id: team_id, role: roles, injury_status: "Uninjured")
  end

  def get_passing_rating(team_id)
    quaterbacks = get_players(team_id, "QB")
    offensive_tackles = get_players(team_id, "OT")
    interior_offensive_linemen = get_players(team_id, "IOL")
    blockers = get_players(team_id, "TE", "FB")

    # QB Passing Rating Calculations
    quarterback_rating = Calculate::Quarterback.new(category: "passing", players: quaterbacks).rating

    # OT Pass Protection Rating Calculations
    offensive_tackle_rating = Calculate::OffensiveTackle.new(category: "pass_blocking", players: offensive_tackles).rating

    # IOL Pass Protection Rating Calculations
    interior_offensive_line_rating = Calculate::InteriorOffensiveLine.new(category: "pass_blocking", players: interior_offensive_linemen).rating

    # TE/FB Pass Protection Rating Calculations
    blocker_rating = Calculate::TightEnd.new(category: "blocking", players: blockers).rating

    # Final Passing Rating Calculations
    [
      quarterback_rating * 0.73.to_d,
      offensive_tackle_rating * 0.14.to_d,
      interior_offensive_line_rating * 0.12.to_d,
      blocker_rating * 0.01.to_d
    ].sum
  end

  def get_rushing_rating(team_id, styles = [])
    runningbacks = get_players(team_id, "HB")
    interior_offensive_linemen = get_players(team_id, "IOL")
    offensive_tackles = get_players(team_id, "OT")
    blockers = get_players(team_id, "TE", "FB")

    # HB Rushing Rating Calculations
    runningback = Calculate::Runningback.new(category: "rushing", players: runningbacks)
    runningback_rating = runningback.rating
    styles << runningback.rushing_style

    # IOL Run Blocking Rating Calculations
    offensive_lineman = Calculate::InteriorOffensiveLine.new(category: "run_blocking", players: interior_offensive_linemen)
    interior_offensive_line_rating = offensive_lineman.rating
    styles += offensive_lineman.run_blocking_styles

    # OT Run Blocking Rating Calculations
    offensive_tackle = Calculate::OffensiveTackle.new(category: "run_blocking", players: offensive_tackles)
    offensive_tackle_rating = offensive_tackle.rating
    styles += offensive_tackle.run_blocking_styles

    # TE/FB Run Blocking Rating Calculations
    blocker_rating = Calculate::TightEnd.new(category: "blocking", players: blockers).rating

    # Final Rushing Rating Calculations
    rushing_rating = [
      runningback_rating * 0.19.to_d,
      interior_offensive_line_rating * 0.51.to_d,
      offensive_tackle_rating * 0.24.to_d,
      blocker_rating * 0.06.to_d
    ].sum

    # Rushing Scheme Bonus
    runningback.rushing_scheme_bonus(rushing_rating, styles)
  end

  def get_receiving_rating(team_id, styles = [])
    wide_receivers = get_players(team_id, "WR")
    tight_ends = get_players(team_id, "TE")
    runningbacks = get_players(team_id, "HB", "FB")

    # WR Receiving Rating Calculations
    receiving_core = Calculate::WideReceiver.new(category: "receiving", players: wide_receivers)
    wide_receiver_rating = receiving_core.rating
    styles += receiving_core.receiving_styles

    # TE Receiving Rating Calculations
    tight_end = Calculate::TightEnd.new(category: "receiving", players: tight_ends)
    tight_end_rating = tight_end.rating
    styles << tight_end.receiving_style

    # HB/FB Receiving Rating Calculations
    runningback_rating = Calculate::Runningback.new(category: "receiving", players: runningbacks).rating

    # Final Receiving Rating Calculations
    receiving_rating = [
      wide_receiver_rating * 0.78.to_d,
      tight_end_rating * 0.16.to_d,
      runningback_rating * 0.06.to_d
    ].sum

    # Receiving Scheme Bonus
    receiving_core.receiving_scheme_bonus(receiving_rating, styles)
  end

  def get_passrush_rating(team_id, styles = [])
    edge_rushers = get_players(team_id, "ED")
    interior_rushers = get_players(team_id, "IDL")

    # ED Pass Rushing Rating Calculations
    edge_rusher = Calculate::Edge.new(category: "pass_rush", players: edge_rushers)
    edge_rush_rating = edge_rusher.rating
    styles += edge_rusher.pass_rush_styles

    # IDL Pass Rushing Rating Calculations
    interior_rusher = Calculate::InteriorDefensiveLine.new(category: "pass_rush", players: interior_rushers)
    interior_rush_rating = interior_rusher.rating
    styles += interior_rusher.pass_rush_styles

    # Final Pass Rushing Rating Calculations
    pass_rush_rating = [
      edge_rush_rating * 0.6.to_d,
      interior_rush_rating * 0.4.to_d
    ].sum

    # Pass Rush Scheme Bonus
    edge_rusher.pass_rush_scheme_bonus(pass_rush_rating, styles)
  end

  def get_rundefense_rating(team_id)
    edge_rushers = get_players(team_id, "ED")
    interior_rushers = get_players(team_id, "IDL")
    linebackers = get_players(team_id, "LB")
    safeties = get_players(team_id, "S")

    # IDL Run Defense Rating Calculations
    interior_defensive_line_rating = Calculate::InteriorDefensiveLine.new(category: "run_defense", players: interior_rushers).rating

    # ED Run Defense Rating Calculations
    edge_rusher_rating = Calculate::Edge.new(category: "run_defense", players: edge_rushers).rating

    # LB Run Defense Rating Calculations
    linebacker_rating = Calculate::Linebacker.new(category: "run_defense", players: linebackers).rating

    # S Run Defense Rating Calculations
    safety_rating = Calculate::Safety.new(category: "run_defense", players: safeties).rating

    # Final Run Defense Rating Calculations
    [
      interior_defensive_line_rating * 0.36.to_d,
      linebacker_rating * 0.28.to_d,
      edge_rusher_rating * 0.2.to_d,
      safety_rating * 0.14.to_d
    ].sum
  end

  def get_passcoverage_rating(team_id, styles = [])
    cornerbacks = get_players(team_id, "CB")
    safeties = get_players(team_id, "S")
    linebackers = get_players(team_id, "LB")

    # CB Coverage Rating Calculations
    coverage_unit = Calculate::Cornerback.new(category: "coverage", players: cornerbacks)
    cornerback_rating = coverage_unit.rating
    styles += coverage_unit.coverage_styles

    # S Coverage Rating Calculations
    safety = Calculate::Safety.new(category: "coverage", players: safeties)
    safety_rating = safety.rating
    styles += safety.coverage_styles

    # LB Coverage Rating Calculations
    linebacker_rating = Calculate::Linebacker.new(category: "coverage", players: linebackers).rating

    # Final Coverage Rating Calculations
    coverage_rating = [
      cornerback_rating * 0.54.to_d,
      safety_rating * 0.28.to_d,
      linebacker_rating * 0.18.to_d
    ].sum

    # Coverage Scheme Bonus
    coverage_unit.coverage_scheme_bonus(coverage_rating, styles)
  end

  def get_offense_rating(team_id, passing_rating, rushing_rating, receiving_rating)
    coach_rating = Coach.select(:offense_rating).find_by(team_id: team_id).offense_rating

    # Final Offense Rating Calculations
    [
      coach_rating.to_d * 0.15.to_d,
      passing_rating.to_d * 0.5.to_d,
      rushing_rating.to_d * 0.15.to_d,
      receiving_rating.to_d * 0.2.to_d
    ].sum
  end

  def get_defense_rating(team_id, passrush_rating, rundefense_rating, passcoverage_rating)
    coach_rating = Coach.select(:defense_rating).find_by(team_id: team_id).defense_rating

    # Final Defense Rating Calculations
    [
      coach_rating.to_d * 0.15.to_d,
      passrush_rating.to_d * 0.2.to_d,
      rundefense_rating.to_d * 0.2.to_d,
      passcoverage_rating.to_d * 0.45.to_d
    ].sum
  end

  def get_specialteams_rating(team_id)
    coach_rating = Coach.select(:specialteams_rating).find_by(team_id: team_id).specialteams_rating
    kickers = get_players(team_id, "K")
    punters = get_players(team_id, "P")

    # K Kicking Rating Calculations
    kicker_rating = Calculate::Kicker.new(category: "kicking", players: kickers).rating

    # P Kicking Rating Calculations
    punter_rating = Calculate::Punter.new(category: "kicking", players: kickers).rating

    # Final Special Teams Rating Calculations
    [
      coach_rating.to_d * 0.25.to_d,
      kicker_rating.to_d * 0.5.to_d,
      punter_rating.to_d * 0.25.to_d
    ].sum
  end
end
