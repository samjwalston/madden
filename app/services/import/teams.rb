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

      team_id = (row[:teamindex].to_i + 1)
      quarterback_rating = get_quarterback_rating(team_id)
      rushing_rating = get_rushing_rating(team_id)
      receiver_rating = get_receiver_rating(team_id)
      passprotect_rating = get_passprotect_rating(team_id)
      passrush_rating = get_passrush_rating(team_id)
      rundefense_rating = get_rundefense_rating(team_id)
      passcoverage_rating = get_passcoverage_rating(team_id)
      specialteams_rating = get_specialteams_rating(team_id)

      offense_rating = [
        quarterback_rating.to_d * 0.36.to_d,
        rushing_rating.to_d * 0.12.to_d,
        receiver_rating.to_d * 0.34.to_d,
        passprotect_rating.to_d * 0.18.to_d
      ].sum.floor.to_i

      defense_rating = [
        passrush_rating.to_d * 0.3.to_d,
        rundefense_rating.to_d * 0.1.to_d,
        passcoverage_rating.to_d * 0.6.to_d
      ].sum.floor.to_i

      overall_rating = [
        offense_rating.to_d * 0.56.to_d,
        defense_rating.to_d * 0.43.to_d,
        specialteams_rating.to_d * 0.01.to_d,
      ].sum.floor.to_i

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
        receiver_rating: receiver_rating,
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

  def get_quarterback_rating(team_id)
    quarterbacks = Player.includes(:categories).where(team_id: team_id, position: "QB")

    rating = quarterbacks.map do |player|
      player.categories.to_a.detect{|p| p.name == "Passer"}.rating.to_d
    end.max

    rating.to_d.floor.to_i
  end

  def get_rushing_rating(team_id)
    runningbacks = Player.includes(:categories).where(team_id: team_id, position: "HB")
    blockers = Player.includes(:categories).where(team_id: team_id, position: ["TE", "FB"])
    left_tackle = Player.includes(:categories).where(team_id: team_id, position: "LT").order(overall_rating: :desc).first
    left_guard = Player.includes(:categories).where(team_id: team_id, position: "LG").order(overall_rating: :desc).first
    center = Player.includes(:categories).where(team_id: team_id, position: "C").order(overall_rating: :desc).first
    right_guard = Player.includes(:categories).where(team_id: team_id, position: "RG").order(overall_rating: :desc).first
    right_tackle = Player.includes(:categories).where(team_id: team_id, position: "RT").order(overall_rating: :desc).first

    runningback_rating = runningbacks.map do |runningback|
      runningback.categories.to_a.detect{|p| p.name == "Runner"}.rating.to_d
    end.max

    blocker_rating = blockers.map do |blocker|
      blocker.categories.to_a.detect{|p| p.name == "Blocker"}.rating.to_d
    end.max

    tackle_rating = ([
      left_tackle.categories.to_a.detect{|p| p.name == "Run Blocker"}.rating.to_d,
      right_tackle.categories.to_a.detect{|p| p.name == "Run Blocker"}.rating.to_d
    ].sum / 3.to_d)

    interior_rating = ([
      left_guard.categories.to_a.detect{|p| p.name == "Run Blocker"}.rating.to_d,
      center.categories.to_a.detect{|p| p.name == "Run Blocker"}.rating.to_d,
      right_guard.categories.to_a.detect{|p| p.name == "Run Blocker"}.rating.to_d
    ].sum / 3.to_d)

    [
      runningback_rating * 0.4.to_d,
      interior_rating * 0.35.to_d,
      tackle_rating * 0.2.to_d,
      blocker_rating * 0.05.to_d
    ].sum.floor.to_i
  end

  def get_receiver_rating(team_id)
    widereceivers = Player.includes(:categories).where(team_id: team_id, position: "WR")
    tightends = Player.includes(:categories).where(team_id: team_id, position: "TE")
    runningbacks = Player.includes(:categories).where(team_id: team_id, position: "HB")

    receivers = widereceivers.sort do |a, b|
      a_rating = a.categories.to_a.detect{|p| p.name == "Outside Receiver"}.rating.to_d
      b_rating = b.categories.to_a.detect{|p| p.name == "Outside Receiver"}.rating.to_d

      b_rating <=> a_rating
    end

    outside_receivers = receivers[0..1]
    slot_receivers = receivers[2..-1]

    outside_rating = (outside_receivers.map do |receiver|
      receiver.categories.to_a.detect{|p| p.name == "Outside Receiver"}.rating.to_d
    end.max(2).sum / 2.to_d)

    slot_rating = slot_receivers.map do |receiver|
      receiver.categories.to_a.detect{|p| p.name == "Slot Receiver"}.rating.to_d
    end.max

    tightend_rating = tightends.map do |tightend|
      tightend.categories.to_a.detect{|p| p.name == "Receiver"}.rating.to_d
    end.max

    runningback_rating = runningbacks.map do |runningback|
      runningback.categories.to_a.detect{|p| p.name == "Receiver"}.rating.to_d
    end.max

    [
      outside_rating * 0.6.to_d,
      slot_rating * 0.2.to_d,
      tightend_rating * 0.15.to_d,
      runningback_rating * 0.05.to_d
    ].sum.floor.to_i
  end

  def get_passprotect_rating(team_id)
    blockers = Player.includes(:categories).where(team_id: team_id, position: ["FB","TE"])
    left_tackle = Player.includes(:categories).where(team_id: team_id, position: "LT").order(overall_rating: :desc).first
    left_guard = Player.includes(:categories).where(team_id: team_id, position: "LG").order(overall_rating: :desc).first
    center = Player.includes(:categories).where(team_id: team_id, position: "C").order(overall_rating: :desc).first
    right_guard = Player.includes(:categories).where(team_id: team_id, position: "RG").order(overall_rating: :desc).first
    right_tackle = Player.includes(:categories).where(team_id: team_id, position: "RT").order(overall_rating: :desc).first

    blocker_rating = blockers.map do |blocker|
      blocker.categories.to_a.detect{|p| p.name == "Blocker"}.rating.to_d
    end.max

    tackle_rating = ([
      left_tackle.categories.to_a.detect{|p| p.name == "Pass Blocker"}.rating.to_d,
      right_tackle.categories.to_a.detect{|p| p.name == "Pass Blocker"}.rating.to_d,
    ].sum / 2.to_d)

    interior_rating = ([
      left_guard.categories.to_a.detect{|p| p.name == "Pass Blocker"}.rating.to_d,
      center.categories.to_a.detect{|p| p.name == "Pass Blocker"}.rating.to_d,
      right_guard.categories.to_a.detect{|p| p.name == "Pass Blocker"}.rating.to_d
    ].sum / 3.to_d)

    [
      tackle_rating * 0.6.to_d,
      interior_rating * 0.35.to_d,
      blocker_rating * 0.05.to_d
    ].sum.floor.to_i
  end

  def get_passrush_rating(team_id)
    rushers = Player.includes(:categories).where(team_id: team_id, position: ["DT", "LE", "RE", "LOLB", "ROLB"])

    edge_rating = (rushers.map do |rusher|
      rusher.categories.to_a.detect{|p| p.name == "Edge Rusher"}.rating.to_d
    end.max(2).sum / 2.to_d)

    interior_rating = (rushers.map do |rusher|
      role = rusher.categories.to_a.detect{|p| p.name == "Interior Rusher"}
      role.nil? ? 0.to_d : role.rating.to_d
    end.max(2).sum / 2.to_d)

    [
      edge_rating * 0.7.to_d,
      interior_rating * 0.3.to_d
    ].sum.floor.to_i
  end

  def get_rundefense_rating(team_id)
    linemen = Player.includes(:categories).where(team_id: team_id, position: ["DT", "LE", "RE"])
    outside_linebackers = Player.includes(:categories).where(team_id: team_id, position: ["LOLB", "ROLB"])
    inside_linebackers = Player.includes(:categories).where(team_id: team_id, position: "MLB")
    safeties = Player.includes(:categories).where(team_id: team_id, position: "SS")

    interior_players = []
    edge_players = []
    offball_players = []

    linemen.each do |lineman|
      interior = lineman.categories.to_a.detect{|p| p.name == "Interior Rusher"}.rating.to_d
      interior.zero? ? (edge_players << lineman) : (interior_players << lineman)
    end

    outside_linebackers.each do |linebacker|
      edge = linebacker.categories.to_a.detect{|p| p.name == "Edge Rusher"}.rating.to_d
      offball = ([
        linebacker.categories.to_a.detect{|p| p.name == "Run Stopper"}.rating.to_d,
        linebacker.categories.to_a.detect{|p| p.name == "Pass Coverage"}.rating.to_d
      ].sum / 2.to_d).floor

      edge >= offball ? (edge_players << linebacker) : (offball_players << linebacker)
    end

    inside_linebackers.each do |linebacker|
      offball_players << linebacker
    end

    interior_rating = (interior_players.map do |lineman|
      lineman.categories.to_a.detect{|p| p.name == "Run Stopper"}.rating.to_d
    end.max(2).sum / 2.to_d)

    edge_rating = (edge_players.map do |lineman|
      lineman.categories.to_a.detect{|p| p.name == "Run Stopper"}.rating.to_d
    end.max(2).sum / 2.to_d)

    linebacker_rating = (offball_players.map do |linebacker|
      linebacker.categories.to_a.detect{|p| p.name == "Run Stopper"}.rating.to_d
    end.max(2).sum / 2.to_d)

    safety_rating = safeties.map do |safety|
      safety.categories.to_a.detect{|p| p.name == "Run Stopper"}.rating.to_d
    end.max

    [
      interior_rating * 0.5.to_d,
      linebacker_rating * 0.3.to_d,
      safety_rating * 0.1.to_d,
      edge_rating * 0.1.to_d
    ].sum.floor.to_i
  end

  def get_passcoverage_rating(team_id)
    defensivebacks = Player.includes(:categories).where(team_id: team_id, position: "CB")
    linebackers = Player.includes(:categories).where(team_id: team_id, position: ["MLB", "LOLB", "ROLB"])
    safeties = Player.includes(:categories).where(team_id: team_id, position: ["FS", "SS"])

    slotback_id = nil
    slot_rating = 0.to_d

    outside_rating = defensivebacks.each do |defensiveback|
      rating = defensiveback.categories.to_a.detect{|p| p.name == "Slot Coverage"}.rating.to_d
      next if slot_rating >= rating
      slotback_id = defensiveback.id
      slot_rating = rating
    end

    outside_rating = (defensivebacks.map do |defensiveback|
      if defensiveback.id == slotback_id
        0
      else
        defensiveback.categories.to_a.detect{|p| p.name == "Outside Coverage"}.rating.to_d
      end
    end.max(2).sum / 2.to_d)

    linebacker_rating = (linebackers.map do |linebacker|
      linebacker.categories.to_a.detect{|p| p.name == "Pass Coverage"}.rating.to_d
    end.max(2).sum / 2.to_d)

    safety_rating = (safeties.map do |safety|
      safety.categories.to_a.detect{|p| p.name == "Pass Coverage"}.rating.to_d
    end.max(2).sum / 2.to_d)

    [
      outside_rating * 0.4.to_d,
      slot_rating * 0.2.to_d,
      safety_rating * 0.25.to_d,
      linebacker_rating * 0.15.to_d
    ].sum.floor.to_i
  end

  def get_specialteams_rating(team_id)
    kicker = Player.includes(:categories).where(team_id: team_id, position: "K").order(overall_rating: :desc).first
    punter = Player.includes(:categories).where(team_id: team_id, position: "P").order(overall_rating: :desc).first

    [
      kicker.categories.to_a.detect{|p| p.name == "Kicker"}.rating.to_d * 0.7.to_d,
      punter.categories.to_a.detect{|p| p.name == "Kicker"}.rating.to_d * 0.3.to_d
    ].sum.floor.to_i
  end
end
