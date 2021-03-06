class Calculate::Kicker < Calculate::Position
  PLAYER_VALUE = 0.02.to_d.freeze
  PROSPECT_VALUE = 0.9.to_d.freeze


  private

  def role_name
    "K"
  end

  def roles
    @roles ||= ["Power", "Accurate"]
  end

  # Player(archetypes)
  # Prospect(archetypes)
  # Team:Kicking(players)
  def calculate_rating
    kicking_rating
  end

  # Player(archetypes)
  # Prospect(archetypes)
  # FreeAgency(players)
  def calculate_value
    if @category == "player"
      (kicking_rating * PLAYER_VALUE).round(4)
    elsif @category == "prospect"
      (kicking_rating * PROSPECT_VALUE)
    elsif @category == "free_agency"
      (kicking_rating * PLAYER_VALUE).round(2).to_f
    end
  end

  def kicking_rating
    @kicking_rating ||= get_roles(1)[:overall_rating]
  end
end
