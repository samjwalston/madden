module FreeAgencyHelpers
  def qb_value(*names)
    Calculate::Quarterback.new(category: "free_agency", players: get_players(names, "QB")).value
  end

  def rb_value(*names)
    Calculate::Runningback.new(category: "free_agency", players: get_players(names, "HB")).value
  end

  def wr_value(*names)
    Calculate::WideReceiver.new(category: "free_agency", players: get_players(names, "WR")).value
  end

  def te_value(*names)
    Calculate::TightEnd.new(category: "free_agency", players: get_players(names, "TE")).value
  end

  def ot_value(*names)
    Calculate::OffensiveTackle.new(category: "free_agency", players: get_players(names, "LT", "RT")).value
  end

  def iol_value(*names)
    Calculate::InteriorOffensiveLine.new(category: "free_agency", players: get_players(names, "LG", "C", "RG")).value
  end

  # def get_edge_rusher_rating(*names)
  #   players = Player.includes(:archetypes, :role).where(position: ["DT", "LE", "RE", "LOLB", "ROLB"], name: names)
  #   Calculate::Edge.call(players).player_value
  # end

  # def get_interior_defensive_line_rating(*names)
  #   players = Player.includes(:archetypes, :role).where(position: ["DT", "LE", "RE", "LOLB", "ROLB"], name: names)
  #   Calculate::InteriorDefensiveLine.call(players).player_value
  # end

  # def get_linebacker_rating(*names)
  #   players = Player.includes(:archetypes, :role).where(position: ["MLB", "LOLB", "ROLB"], name: names)
  #   Calculate::Linebacker.call(players).player_value
  # end

  # def get_cornerback_rating(*names)
  #   players = Player.includes(:role).where(position: "CB", name: names)
  #   Calculate::Cornerback.call(players).player_value
  # end

  # def get_safety_rating(*names)
  #   players = Player.includes(:archetypes, :role).where(position: ["FS", "SS"], name: names)
  #   Calculate::Safety.call(players).player_value
  # end


  private

  def get_players(names, *positions)
    Player.includes(:archetypes).where(position: positions, name: names)
  end
end
