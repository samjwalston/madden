class Calculate::Safety < Calculate::Position
  PLAYER_VALUE = 0.0293.to_d.freeze
  PROSPECT_VALUE = 0.9732.to_d.freeze


  def coverage_styles
    coverage_rating(2) if @coverage_styles.nil?
    @coverage_styles
  end


  private

  def role_name
    "S"
  end

  def roles
    @roles ||= ["Run Support", "Zone", "Hybrid"]
  end

  # Player(archetypes)
  # Prospect(archetypes)
  # Team:Coverage(players)
  # Team:RunDefense(players)
  def calculate_rating
    if @category.in?(["player", "prospect"])
      coverage_rating
    elsif @category == "coverage"
      coverage_rating(2)
    elsif @category == "run_defense"
      run_defense_rating(2)
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
      (total_rating(2) * (PLAYER_VALUE * 2)).round(2).to_f
    end
  end

  def coverage_rating(player_count = 1)
    @coverage_rating unless @coverage_rating.nil?
    @coverage_styles = []
    archetypes = get_roles(player_count, "Zone", "Hybrid")

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

  def run_defense_rating(player_count = 1)
    @run_defense_rating unless @run_defense_rating.nil?
    archetypes = get_roles(player_count, "Run Support")

    if player_count == 1
      @run_defense_rating = archetypes[:overall_rating]
    else
      @run_defense_rating = (archetypes.map do |archetype|
        archetype[:overall_rating]
      end.sum / player_count.to_d)
    end
  end

  def total_rating(player_count = 1)
    [coverage_rating(player_count).to_d * 0.8191.to_d, run_defense_rating(player_count).to_d * 0.1809.to_d].sum
  end
end
