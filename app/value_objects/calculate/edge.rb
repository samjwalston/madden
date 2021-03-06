class Calculate::Edge < Calculate::Position
  PLAYER_VALUE = 0.0305.to_d.freeze
  PROSPECT_VALUE = 0.9762.to_d.freeze


  def role
    run_defense_rating > pass_rush_rating || coverage_rating > pass_rush_rating ? nil : super
  end


  private

  def role_name
    "ED"
  end

  def roles
    @roles ||= ["Run Stopper", "Power Rusher", "Speed Rusher"]
  end

  # Player(archetypes)
  # Prospect(archetypes)
  # Team:PassRush(players)
  # Team:RunDefense(players)
  def calculate_rating
    if @category.in?(["player", "prospect"])
      total_rating.round
    elsif @category == "pass_rush"
      pass_rush_rating(2)
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

  def pass_rush_rating(player_count = 1)
    @pass_rush_rating unless @pass_rush_rating.nil?
    archetypes = get_roles(player_count, "Power Rusher", "Speed Rusher")

    if player_count == 1
      @pass_rush_rating = archetypes[:overall_rating]
    else
      @pass_rush_rating = (archetypes.map do |archetype|
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

  def coverage_rating
    @coverage_rating ||= get_roles(1, "Pass Coverage").to_h[:overall_rating].to_i
  end

  def total_rating(player_count = 1)
    [pass_rush_rating(player_count).to_d * 0.7508.to_d, run_defense_rating(player_count).to_d * 0.2492.to_d].sum
  end
end
