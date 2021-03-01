module FreeAgencyHelpers
  def qb_value(*names)
    Calculate::Quarterback.new(category: "free_agency", players: get_players(names, "QB")).value
  end

  def rb_value(*names)
    Calculate::Runningback.new(category: "free_agency", players: get_players(names, "HB")).value
  end

  # def get_receiver_rating(*names)
  #   players = Player.includes(:role).where(position: "WR", name: names)
  #   Calculate::WideReceiver.call(players).player_value
  # end

  # def get_tightend_rating(*names)
  #   players = Player.includes(:archetypes, :role).where(position: "TE", name: names)
  #   Calculate::TightEnd.call(players).player_value
  # end

  # def get_offensive_tackle_rating(*names)
  #   players = Player.includes(:archetypes, :role).where(position: ["LT", "RT"], name: names)
  #   Calculate::OffensiveTackle.call(players).player_value
  # end

  # def get_interior_offensive_line_rating(*names)
  #   players = Player.includes(:archetypes, :role).where(position: ["LG", "C", "RG"], name: names)
  #   Calculate::InteriorOffensiveLine.call(players).player_value
  # end

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
