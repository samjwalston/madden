class Calculate::Cornerback < Calculate::Position
  PLAYER_VALUE = 0.0309.to_d.freeze
  PROSPECT_VALUE = 0.9772.to_d.freeze


  def coverage_styles
    coverage_rating(3) if @coverage_styles.nil?
    @coverage_styles
  end

  def coverage_scheme_bonus(base_rating, styles)
    styles = styles.sort

    if styles == ["Hybrid", "Man to Man", "Man to Man", "Slot", "Zone"]
      base_rating * 1.03.to_d
    elsif styles == ["Hybrid", "Slot", "Zone", "Zone", "Zone"]
      base_rating * 1.03.to_d
    else
      base_rating
    end
  end


  private

  def role_name
    "CB"
  end

  def roles
    @roles ||= ["Slot", "Man to Man", "Zone"]
  end

  # Player(archetypes)
  # Prospect(archetypes)
  # Team:Coverage(players)
  def calculate_rating
    if @category.in?(["player", "prospect"])
      total_rating
    elsif @category == "coverage"
      total_rating(3)
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
      (total_rating(3) * (PLAYER_VALUE * 3)).round(2).to_f
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

  def zone_rating(player_count = 1)
    @zone_rating unless @zone_rating.nil?
    archetypes = get_roles(player_count, "Zone")

    if player_count == 1
      @zone_rating = archetypes[:overall_rating]
    else
      @zone_rating = (archetypes.map do |archetype|
        archetype[:overall_rating]
      end.sum / player_count.to_d)
    end
  end

  def total_rating(player_count = 1)
    [coverage_rating(player_count).to_d * 0.75.to_d, zone_rating(player_count).to_d * 0.25.to_d].sum
  end
end
