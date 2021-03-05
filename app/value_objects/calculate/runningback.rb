class Calculate::Runningback < Calculate::Position
  PLAYER_VALUE = 0.0227.to_d.freeze
  PROSPECT_VALUE = 0.9568.to_d.freeze


  def rushing_style
    rushing_rating if @rushing_style.nil?
    @rushing_style
  end

  def rushing_scheme_bonus(base_rating, styles) # :TODO:
    base_rating
  end


  private

  def role_name
    "HB"
  end

  def roles
    @roles ||= ["Receiving Back", "Power Back", "Elusive Back"]
  end

  # Player(archetypes)
  # Prospect(archetypes)
  # Team:Rushing(players)
  # Team:Receiving(players)
  def calculate_rating
    if @category.in?(["player", "prospect"])
      total_rating.round
    elsif @category == "rushing"
      rushing_rating
    elsif @category == "receiving"
      receiving_rating
    end
  end

  # Player(archetypes)
  # Prospect(archetypes)
  # FreeAgency(players)
  def calculate_value
    if @category == "player"
      (total_rating * PLAYER_VALUE).round(4)
    elsif @category == "prospect"
      (total_rating * PROSPECT_VALUE)
    elsif @category == "free_agency"
      (total_rating * PLAYER_VALUE).round(2).to_f
    end
  end

  def rushing_rating
    @rushing_rating unless @rushing_rating.nil?
    archetype = get_roles(1, "Elusive Back", "Power Back")
    @rushing_style = archetype[:name]
    @rushing_rating = archetype[:overall_rating]
  end

  def receiving_rating
    @receiving_rating ||= get_roles(1, "Receiving Back", "Utility")[:overall_rating]
  end

  def total_rating
    [rushing_rating.to_d * 0.7665.to_d, receiving_rating.to_d * 0.2335.to_d].sum
  end
end
