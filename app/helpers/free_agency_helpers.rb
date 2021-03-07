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

  def player_trade_value(position, rating, age)
    positions = {"QB": 8,"CB": 4,"OT": 4,"ED": 4,"WR": 4,"S": 3,"IDL": 3,"TE": 3,"IOL": 2,"LB": 2,"HB": 2}.map{|k,v| [k.to_s,v.to_d]}.to_h
    ratings = [-1,-0.9,-0.8,-0.7,-0.6,-0.5,-0.4,-0.3,-0.2,-0.1,0,0.05,0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.6,0.7,0.8,0.9,1,1.1,1.2,1.3,1.4,1.5,1.7,1.9,2.1,2.3,2.5,2.8,3.1,3.4,3.7].map(&:to_d)
    ages = [1.25,1,0.83,0.67,0.5,0.33,0.17,0,-0.17,-0.33,-0.5,-0.6,-0.7,-0.8,-0.9,-1,-1.05,-1.1,-1.15,-1.2,-1.25].map(&:to_d)

    ((positions[position] || 0.to_d) * (1.to_d + ratings[rating - 60] + ages[age - 20])).round(3).to_f
  end

  def pick_trade_value(pick)
    picks = [
      10,9.8,9.6,9.4,9.2,9,8.9,8.8,8.7,8.6,8.5,8.4,8.3,8.2,8.1,8,7.94,7.88,7.82,7.76,7.7,7.64,7.58,7.52,7.46,7.4,7.34,7.28,7.22,7.16,7.1,7.06,7,6.93,6.87,6.81,6.75,6.68,6.62,6.56,6.5,6.43,6.37,6.31,6.25,6.18,6.12,6.06,6,5.93,5.87,5.81,5.75,5.68,5.62,5.56,5.5,5.43,5.37,5.31,5.25,5.18,5.12,5.06,5,4.93,4.87,4.81,4.75,4.68,4.62,4.56,4.5,4.43,4.37,4.31,4.25,4.18,4.12,4.06,4,3.93,3.87,3.81,3.75,3.68,3.62,3.56,3.5,3.43,3.37,3.31,3.25,3.18,3.12,3.06,3,2.95,2.9,2.85,2.8,2.75,2.7,2.65,2.6,2.55,2.5,2.45,2.4,2.35,2.3,2.25,2.2,2.15,2.1,2.05,2,1.95,1.9,1.86,1.82,1.78,1.74,1.7,1.66,1.62,1.58,1.54,1.5,1.48,1.46,1.44,1.42,1.4,1.38,1.36,1.34,1.32,1.3,1.28,1.26,1.24,1.22,1.2,1.18,1.16,1.14,1.13,1.12,1.11,1.1,1.09,1.08,1.07,1.06,1.05,1.04,1.03,1.02,1.01,1,0.98,0.96,0.94,0.92,0.9,0.88,0.86,0.84,0.82,0.8,0.78,0.76,0.74,0.72,0.7,0.68,0.66,0.64,0.63,0.62,1.61,0.6,0.59,0.58,0.57,0.56,0.55,0.54,0.53,0.52,0.51,0.5,0.48,0.46,0.44,0.42,0.4,0.38,0.36,0.34,0.32,0.3,0.28,0.26,0.24,0.22,0.2,0.18,0.16,0.14,0.13,0.12,0.11,0.1,0.09,0.08,0.07,0.06,0.05,0.04,0.03,0.02,0.01
    ]

    picks[pick - 1].to_f
  end


  private

  def get_players(names, *positions)
    Player.includes(:archetypes).where(position: positions, name: names)
  end
end
