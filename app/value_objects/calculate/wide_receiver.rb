class Calculate::WideReceiver < Calculate::Position
  PLAYER_VALUE = 0.0347.to_d.freeze
  PROSPECT_VALUE = 0.9868.to_d.freeze

  RECEIVING_CORE_VALUE = 0.1041.to_d.freeze


  def receiving_styles
    receiving_rating(3) if @receiving_styles.nil?
    @receiving_styles
  end

  def receiving_scheme_bonus(base_rating, styles) # :TODO:
    base_rating
  end


  private

  def role_name
    "WR"
  end

  # Player(archetypes)
  # Prospect(archetypes)
  # Team:Receiving(players)
  def calculate_rating
    if @category.in?(["player", "prospect"])
      receiving_rating
    elsif @category == "receiving"
      receiving_rating(3)
    end
  end

  # Player(archetypes)
  # Prospect(archetypes)
  # FreeAgency(players)
  def calculate_value
    if @category == "player"
      (receiving_rating * PLAYER_VALUE).round(4)
    elsif @category == "prospect"
      (receiving_rating * PROSPECT_VALUE).round(4)
    elsif @category == "free_agency"
      (scheme_fit_bonus(receiving_rating(3)) * RECEIVING_CORE_VALUE).round(2).to_f
    end
  end

  def receiving_rating(player_count = 1)
    @receiving_rating unless @receiving_rating.nil?
    @receiving_styles = []
    archetypes = get_roles(player_count)

    if player_count == 1
      @receiving_styles << archetypes[:name]
      @receiving_rating = archetypes[:overall_rating]
    else
      @receiving_rating = (archetypes.map do |archetype|
        @receiving_styles << archetype[:name]
        archetype[:overall_rating]
      end.sum / player_count.to_d)
    end
  end
end
