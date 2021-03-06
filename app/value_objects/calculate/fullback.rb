class Calculate::Fullback < Calculate::Position
  PLAYER_VALUE = 0.0162.to_d.freeze
  PROSPECT_VALUE = 0.8.to_d.freeze


  private

  def role_name
    "FB"
  end

  def roles
    @roles ||= ["Blocking", "Utility"]
  end

  # Player(archetypes)
  # Prospect(archetypes)
  def calculate_rating
    if @category.in?(["player", "prospect"])
      total_rating.round
    end
  end

  # Player(archetypes)
  # Prospect(archetypes)
  def calculate_value
    if @category == "player"
      (total_rating * PLAYER_VALUE).round(4)
    elsif @category == "prospect"
      (total_rating * PROSPECT_VALUE)
    end
  end

  def receiving_rating
    @receiving_rating ||= get_roles(1, "Utility")[:overall_rating]
  end

  def blocking_rating
    @blocking_rating ||= get_roles(1, "Blocking")[:overall_rating]
  end

  def total_rating
    [receiving_rating.to_d * 0.5.to_d, blocking_rating.to_d * 0.5.to_d].sum
  end
end
