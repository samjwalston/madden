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

  def ed_value(*names)
    Calculate::Edge.new(category: "free_agency", players: get_players(names, "DT", "LE", "RE", "LOLB", "ROLB")).value
  end

  def idl_value(*names)
    Calculate::InteriorDefensiveLine.new(category: "free_agency", players: get_players(names, "DT", "LE", "RE", "LOLB", "ROLB")).value
  end

  def lb_value(*names)
    Calculate::Linebacker.new(category: "free_agency", players: get_players(names, "LOLB", "MLB", "ROLB")).value
  end

  def cb_value(*names)
    Calculate::Cornerback.new(category: "free_agency", players: get_players(names, "CB")).value
  end

  def s_value(*names)
    Calculate::Safety.new(category: "free_agency", players: get_players(names, "FS", "SS")).value
  end


  private

  def get_players(names, *positions)
    Player.includes(:archetypes).where(position: positions, name: names)
  end
end
