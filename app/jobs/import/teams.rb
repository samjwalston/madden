class Import::Teams < ApplicationJob
  require 'csv'


  def perform_now
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
      quarterback_rating = get_quarterback_rating(team_id)
      rushing_rating = 0#get_rushing_rating(team_id)
      receiving_rating = 0#get_receiving_rating(team_id)
      passprotect_rating = 0#get_passprotect_rating(team_id)
      passrush_rating = 0#get_passrush_rating(team_id)
      rundefense_rating = 0#get_rundefense_rating(team_id)
      passcoverage_rating = 0#get_passcoverage_rating(team_id)

      offense_rating = 0#get_offense_rating(team_id, quarterback_rating, rushing_rating, receiving_rating, passprotect_rating)
      defense_rating = 0#get_defense_rating(team_id, passrush_rating, rundefense_rating, passcoverage_rating)
      specialteams_rating = 0#get_specialteams_rating(team_id)

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
      "Redskins"=>{"Conference"=>"NFC", "Division"=>"East"},
      "Saints"=>{"Conference"=>"NFC", "Division"=>"South"},
      "Seahawks"=>{"Conference"=>"NFC", "Division"=>"West"},
      "Steelers"=>{"Conference"=>"AFC", "Division"=>"North"},
      "Texans"=>{"Conference"=>"AFC", "Division"=>"South"},
      "Titans"=>{"Conference"=>"AFC", "Division"=>"South"},
      "Vikings"=>{"Conference"=>"NFC", "Division"=>"North"},
    }
  end

  def get_players(team_id, *positions)
    Player.includes(:archetypes).where(team_id: team_id, position: positions, injury_status: "Uninjured")
  end

  def get_quarterback_rating(team_id)
    quaterbacks = get_players(team_id, "QB")
    Calculate::Quarterback.new(players: quaterbacks).rating rescue 0
  end

  # def get_rushing_rating(team_id, styles = [])
  #   runningbacks = Player.includes(:archetypes, :role).where(team_id: team_id, position: "HB", injury_status: "Uninjured")
  #   interior_offensive_linemen = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["LG", "C", "RG"], injury_status: "Uninjured")
  #   offensive_tackles = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["LT", "RT"], injury_status: "Uninjured")
  #   blockers = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["TE", "FB"], injury_status: "Uninjured")
  #
  #   # HB Rushing Rating Calculations
  #   runningback = Calculate::Runningback.call(runningbacks)
  #   runningback_rating = runningback.team_value("rushing")
  #   styles << (runningback.rushing_style == "Elusive Back" ? "Finesse" : "Power")
  #
  #   # IOL Rushing Rating Calculations
  #   offensive_lineman = Calculate::InteriorOffensiveLine.call(interior_offensive_linemen)
  #   interior_offensive_line_rating = offensive_lineman.team_value("run_blocking")
  #   styles << (offensive_lineman.run_block_styles.map{|s| s == "Agile" ? "Finesse" : "Power"})
  #
  #   # OT Rushing Rating Calculations
  #   offensive_tackle = Calculate::OffensiveTackle.call(offensive_tackles)
  #   offensive_tackle_rating = offensive_tackle.team_value("run_blocking")
  #   styles << (offensive_tackle.run_block_styles.map{|s| s == "Agile" ? "Finesse" : "Power"})
  #
  #   # TE/FB Rushing Rating Calculations
  #   blocker_rating = Calculate::TightEnd.call(blockers).team_value("blocking")
  #
  #   # Final Rushing Rating Calculations
  #   rushing_rating = [
  #     runningback_rating * 0.25.to_d,
  #     interior_offensive_line_rating * 0.45.to_d,
  #     offensive_tackle_rating * 0.24.to_d,
  #     blocker_rating * 0.06.to_d
  #   ].sum
  #
  #   # Rushing Scheme Bonus
  #   styles.uniq.size == 1 ? (rushing_rating * 1.03.to_d).round(2) : rushing_rating.round(2)
  # end

  # def get_receiving_rating(team_id)
  #   wide_receivers = Player.includes(:role).where(team_id: team_id, position: "WR", injury_status: "Uninjured")
  #   tight_ends = Player.includes(:role).where(team_id: team_id, position: "TE", injury_status: "Uninjured")
  #   runningbacks = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["HB", "FB"], injury_status: "Uninjured")
  #
  #   # WR Receiving Rating Calculations
  #   receiving_core = Calculate::WideReceiver.call(wide_receivers)
  #   wide_receiver_rating = receiving_core.team_value
  #
  #   # TE Receiving Rating Calculations
  #   tight_end_rating = Calculate::TightEnd.call(tight_ends).team_value("receiving")
  #
  #   # HB/FB Receiving Rating Calculations
  #   runningback_rating = Calculate::Runningback.call(runningbacks).team_value("receiving")
  #
  #   # Final Receiving Rating Calculations
  #   receiving_rating = [
  #     wide_receiver_rating * 0.78.to_d,
  #     tight_end_rating * 0.18.to_d,
  #     runningback_rating * 0.04.to_d
  #   ].sum
  #
  #   # Receiving Scheme Bonus
  #   receiving_core.scheme_fit_bonus(receiving_rating).round(2)
  # end

  # def get_passprotect_rating(team_id)
  #   offensive_tackles = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["LT", "RT"], injury_status: "Uninjured")
  #   interior_offensive_linemen = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["LG", "C", "RG"], injury_status: "Uninjured")
  #   blockers = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["TE"], injury_status: "Uninjured")
  #
  #   # OT Pass Protection Rating Calculations
  #   offensive_tackle_rating = Calculate::OffensiveTackle.call(offensive_tackles).team_value("pass_blocking")
  #
  #   # IOL Pass Protection Rating Calculations
  #   interior_offensive_line_rating = Calculate::InteriorOffensiveLine.call(interior_offensive_linemen).team_value("pass_blocking")
  #
  #   # TE Pass Protection Rating Calculations
  #   blocker_rating = Calculate::TightEnd.call(blockers).team_value("blocking")
  #
  #   # Final Pass Protection Rating Calculations
  #   [
  #     offensive_tackle_rating * 0.56.to_d,
  #     interior_offensive_line_rating * 0.42.to_d,
  #     blocker_rating * 0.02.to_d
  #   ].sum.round(2)
  # end

  # def get_passrush_rating(team_id)
  #   defensive_linemen = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["DT", "LE", "RE", "LOLB", "ROLB"], injury_status: "Uninjured")
  #
  #   # EDGE Pass Rushing Rating Calculations
  #   edge_rusher = Calculate::Edge.call(defensive_linemen)
  #   edge_rusher_rating = edge_rusher.team_value("pass_rush")
  #
  #   # IDL Pass Rushing Rating Calculations
  #   interior_defensive_line_rating = Calculate::InteriorDefensiveLine.call(defensive_linemen).team_value("pass_rush")
  #
  #   # Final Pass Rushing Rating Calculations
  #   pass_rush_rating = [
  #     edge_rusher_rating * 0.66.to_d,
  #     interior_defensive_line_rating * 0.34.to_d
  #   ].sum
  #
  #   # Pass Rushing Scheme Bonus
  #   edge_rusher.scheme_fit_bonus(pass_rush_rating).round(2)
  # end

  # def get_rundefense_rating(team_id)
  #   defensive_linemen = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["DT", "LE", "RE", "LOLB", "ROLB"], injury_status: "Uninjured")
  #   linebackers = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["LOLB", "MLB", "ROLB"], injury_status: "Uninjured")
  #   safeties = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["FS", "SS"], injury_status: "Uninjured")
  #
  #   # IDL Run Defense Rating Calculations
  #   interior_defensive_line_rating = Calculate::InteriorDefensiveLine.call(defensive_linemen).team_value("run_defense")
  #
  #   # EDGE Run Defense Rating Calculations
  #   edge_rusher_rating = Calculate::Edge.call(defensive_linemen).team_value("run_defense")
  #
  #   # LB Run Defense Rating Calculations
  #   linebacker_rating = Calculate::Linebacker.call(linebackers).team_value("run_defense")
  #
  #   # S Run Defense Rating Calculations
  #   safety_rating = Calculate::Safety.call(safeties).team_value("run_defense")
  #
  #   # Final Run Defense Rating Calculations
  #   [
  #     interior_defensive_line_rating * 0.4.to_d,
  #     linebacker_rating * 0.32.to_d,
  #     edge_rusher_rating * 0.16.to_d,
  #     safety_rating * 0.12.to_d
  #   ].sum.round(2)
  # end

  # def get_passcoverage_rating(team_id)
  #   cornerbacks = Player.includes(:role).where(team_id: team_id, position: "CB", injury_status: "Uninjured")
  #   safeties = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["FS", "SS"], injury_status: "Uninjured")
  #   linebackers = Player.includes(:archetypes, :role).where(team_id: team_id, position: ["MLB", "LOLB", "ROLB"], injury_status: "Uninjured")
  #
  #   # CB Coverage Rating Calculations
  #   cornerback = Calculate::Cornerback.call(cornerbacks)
  #   cornerback_rating = cornerback.team_value
  #
  #   # S Coverage Rating Calculations
  #   safety_rating = Calculate::Safety.call(safeties).team_value("coverage")
  #
  #   # LB Coverage Rating Calculations
  #   linebacker_rating = Calculate::Linebacker.call(linebackers).team_value("coverage")
  #
  #   # Final Coverage Rating Calculations
  #   coverage_rating = [
  #     cornerback_rating * 0.55.to_d,
  #     safety_rating * 0.25.to_d,
  #     linebacker_rating * 0.2.to_d
  #   ].sum
  #
  #   # Coverage Scheme Bonus
  #   cornerback.scheme_fit_bonus(coverage_rating).round(2)
  # end

  # def get_offense_rating(team_id, quarterback_rating, rushing_rating, receiving_rating, passprotect_rating)
  #   coach = Coach.find_by(team_id: team_id)
  #
  #   [
  #     coach.offense_rating.to_d * 0.13.to_d,
  #     quarterback_rating.to_d * 0.38.to_d,
  #     rushing_rating.to_d * 0.12.to_d,
  #     receiving_rating.to_d * 0.23.to_d,
  #     passprotect_rating.to_d * 0.14.to_d
  #   ].sum.round(2)
  # end

  # def get_defense_rating(team_id, passrush_rating, rundefense_rating, passcoverage_rating)
  #   coach = Coach.find_by(team_id: team_id)
  #
  #   [
  #     coach.defense_rating.to_d * 0.2.to_d,
  #     passrush_rating.to_d * 0.24.to_d,
  #     rundefense_rating.to_d * 0.12.to_d,
  #     passcoverage_rating.to_d * 0.44.to_d,
  #   ].sum.round(2)
  # end

  # def get_specialteams_rating(team_id)
  #   coach = Coach.find_by(team_id: team_id)
  #   kickers = Player.includes(:role).where(team_id: team_id, position: "K", injury_status: "Uninjured")
  #   punters = Player.includes(:role).where(team_id: team_id, position: "P", injury_status: "Uninjured")
  #
  #   # K Special Teams Rating Calculations
  #   kicker_rating = begin
  #     Calculate::Kicker.call(kickers).team_value
  #   rescue
  #     Calculate::Punter.call(punters).team_value
  #   end
  #
  #   # P Special Teams Rating Calculations
  #   punter_rating = begin
  #     Calculate::Punter.call(punters).team_value
  #   rescue
  #     Calculate::Kicker.call(kickers).team_value
  #   end
  #   # Final Special Teams Rating Calculations
  #   [
  #     coach.specialteams_rating.to_d * 0.5.to_d,
  #     kicker_rating.to_d * 0.3.to_d,
  #     punter_rating.to_d * 0.2.to_d
  #   ].sum.round(2)
  # end
end
