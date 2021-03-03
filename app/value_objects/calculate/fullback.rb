class Calculate::Fullback < Calculate::Position
  PLAYER_VALUE = 0.0095.to_d.freeze
  PLAYER_RECEIVING_VALUE = 0.0053.to_d.freeze # 55.79%
  PLAYER_BLOCKING_VALUE = 0.0042.to_d.freeze  # 44.21%

  PROSPECT_VALUE = 0.8211.to_d.freeze
  PROSPECT_RECEIVING_VALUE = 0.4581.to_d.freeze
  PROSPECT_BLOCKING_VALUE = 0.363.to_d.freeze


  private

  def role_name
    "FB"
  end

  # Player(archetypes)
  # Prospect(archetypes)
  def calculate_rating
    if @category.in?(["player", "prospect"])
      ([receiving_rating, blocking_rating].sum.to_d / 2.to_d).floor
    end
  end

  # Player(archetypes)
  # Prospect(archetypes)
  def calculate_value
    if @category == "player"
      ((receiving_rating * PLAYER_RECEIVING_VALUE) + (blocking_rating * PLAYER_BLOCKING_VALUE)).round(4)
    elsif @category == "prospect"
      ((receiving_rating * PROSPECT_RECEIVING_VALUE) + (blocking_rating * PROSPECT_BLOCKING_VALUE)).round(4)
    end
  end

  def receiving_rating
    @receiving_rating ||= get_roles(1, "Utility")[:overall_rating]
  end

  def blocking_rating
    @blocking_rating ||= get_roles(1, "Blocking")[:overall_rating]
  end
end
