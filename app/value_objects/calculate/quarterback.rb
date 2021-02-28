class Calculate::Quarterback < Calculate::Position
  PROSPECT_VALUE = 1.to_d.freeze
  PLAYER_VALUE = 0.2204.to_d.freeze


  private

  def role_name
    "QB"
  end

  # Team(players)
  def calculate_rating
    get_roles(1)["overall_rating"]
  end

  # Player(archetypes)
  # Prospect(archetypes)
  # FreeAgency(players)
  def calculate_value
    if @category == "player"
      (get_role[:overall_rating] * PLAYER_VALUE).round(4)
    elsif @category == "prospect"
      (get_role[:overall_rating] * PROSPECT_VALUE).round(4)
    elsif @category == "free_agency"
      get_roles(1)[:overall_rating].round(2).to_f
    end
  end
end
