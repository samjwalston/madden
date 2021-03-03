class Calculate::Cornerback < Calculate::Position
  PLAYER_VALUE = 0.0307.to_d.freeze
  PROSPECT_VALUE = 0.9768.to_d.freeze


  def coverage_styles
    coverage_rating(3) if @coverage_styles.nil?
    @coverage_styles
  end

  def coverage_scheme_bonus(base_rating, styles) # :TODO:
    base_rating
  end


  private

  def role_name
    "CB"
  end

  def roles
    @roles ||= ["Slot", "Zone", "Man to Man"]
  end

  # Player(archetypes)
  # Prospect(archetypes)
  # Team:Coverage(players)
  def calculate_rating
    if @category.in?(["player", "prospect"])
      coverage_rating
    elsif @category == "coverage"
      coverage_rating(3)
    end
  end

  # Player(archetypes)
  # Prospect(archetypes)
  # FreeAgency(players)
  def calculate_value
    if @category == "player"
      (coverage_rating * PLAYER_VALUE).round(4)
    elsif @category == "prospect"
      (coverage_rating * PROSPECT_VALUE).round(4)
    elsif @category == "free_agency"
      (coverage_rating(3) * (PLAYER_VALUE * 3)).round(2).to_f
    end
  end

  def coverage_rating(player_count = 1)
    @coverage_rating unless @coverage_rating.nil?
    @coverage_styles = []
    archetypes = get_roles(player_count)

    if player_count == 1
      @coverage_styles << archetypes[:name]
      @coverage_rating = archetypes[:overall_rating]
    else
      @coverage_rating = (archetypes.map do |archetype|
        @coverage_styles << archetype[:name]
        archetype[:overall_rating]
      end.sum / player_count.to_d)
    end
  end
end
