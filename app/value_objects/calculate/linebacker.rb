class Calculate::Linebacker < Calculate::Position
  PLAYER_VALUE = 0.0261.to_d.freeze
  PROSPECT_VALUE = 0.9652.to_d.freeze


  private

  def role_name
    "LB"
  end

  def roles
    @roles ||= ["Run Stopper", "Pass Coverage", "Field General"]
  end

  # Player(archetypes)
  # Prospect(archetypes)
  # Team:Coverage(players)
  # Team:RunDefense(players)
  def calculate_rating
    if @category.in?(["player", "prospect"])
      total_rating.round
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
    archetypes = get_roles(player_count, "Pass Coverage")

    if player_count == 1
      @coverage_rating = archetypes[:overall_rating]
    else
      @coverage_rating = (archetypes.map do |archetype|
        archetype[:overall_rating]
      end.sum / player_count.to_d)
    end
  end

  def run_defense_rating(player_count = 1)
    @run_defense_rating unless @run_defense_rating.nil?
    archetypes = get_roles(player_count, "Run Stopper")

    if player_count == 1
      @run_defense_rating = archetypes[:overall_rating]
    else
      @run_defense_rating = (archetypes.map do |archetype|
        archetype[:overall_rating]
      end.sum / player_count.to_d)
    end
  end

  def total_rating(player_count = 1)
    [coverage_rating(player_count).to_d * 0.5939.to_d, run_defense_rating(player_count).to_d * 0.4061.to_d].sum
  end
end
