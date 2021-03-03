class Calculate::TightEnd < Calculate::Position
  PLAYER_VALUE = 0.0298.to_d.freeze
  PROSPECT_VALUE = 0.9745.to_d.freeze


  def receiving_style
    receiving_rating if @receiving_style.nil?
    @receiving_style
  end


  private

  def role_name
    "TE"
  end

  def roles
    @roles ||= ["Blocking", "Vertical Threat", "Possession"]
  end

  # Player(archetypes)
  # Prospect(archetypes)
  # Team:Receiving(players)
  # Team:Blocking(players)
  def calculate_rating
    if @category.in?(["player", "prospect"])
      total_rating.round
    elsif @category == "receiving"
      receiving_rating
    elsif @category == "blocking"
      blocking_rating
    end
  end

  # Player(archetypes)
  # Prospect(archetypes)
  # FreeAgency(players)
  def calculate_value
    if @category == "player"
      (total_rating * PLAYER_VALUE).round(4)
    elsif @category == "prospect"
      (total_rating * PROSPECT_VALUE).round(4)
    elsif @category == "free_agency"
      (total_rating * PLAYER_VALUE).round(2).to_f
    end
  end

  def receiving_rating
    @receiving_rating unless @receiving_rating.nil?
    archetype = get_roles(1, "Possession", "Vertical Threat")
    @receiving_style = archetype[:name]
    @receiving_rating = archetype[:overall_rating]
  end

  def blocking_rating
    @blocking_rating ||= get_roles(1, "Blocking")[:overall_rating]
  end

  def total_rating
    [receiving_rating.to_d * 0.8054.to_d, blocking_rating.to_d * 0.1946.to_d].sum
  end
end
