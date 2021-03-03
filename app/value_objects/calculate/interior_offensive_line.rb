class Calculate::InteriorOffensiveLine < Calculate::Position
  PLAYER_VALUE = 0.0218.to_d.freeze
  PROSPECT_VALUE = 0.9545.to_d.freeze


  def run_blocking_styles
    run_blocking_rating if @run_blocking_styles.nil?
    @run_blocking_styles
  end


  private

  def role_name
    "IOL"
  end

  def roles
    @roles ||= ["Power", "Agile", "Pass Protector"]
  end

  # Player(archetypes)
  # Prospect(archetypes)
  # Team:PassBlocking(players)
  # Team:RunBlocking(players)
  def calculate_rating
    if @category.in?(["player", "prospect"])
      total_rating.round
    elsif @category == "pass_blocking"
      pass_blocking_rating(3)
    elsif @category == "run_blocking"
      run_blocking_rating(3)
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
      (total_rating(3) * (PLAYER_VALUE * 3)).round(2).to_f
    end
  end

  def pass_blocking_rating(player_count = 1)
    @pass_blocking_rating unless @pass_blocking_rating.nil?
    archetypes = get_roles(player_count, "Pass Protector")

    if player_count == 1
      @pass_blocking_rating = archetypes[:overall_rating]
    else
      @pass_blocking_rating = (archetypes.map do |archetype|
        archetype[:overall_rating]
      end.sum / player_count.to_d)
    end
  end

  def run_blocking_rating(player_count = 1)
    @run_blocking_rating unless @run_blocking_rating.nil?
    @run_blocking_styles = []
    archetypes = get_roles(player_count, "Agile", "Power")

    if player_count == 1
      @run_blocking_styles << archetypes[:name]
      @run_blocking_rating = archetypes[:overall_rating]
    else
      @run_blocking_rating = (archetypes.map do |archetype|
        @run_blocking_styles << archetype[:name]
        archetype[:overall_rating]
      end.sum / player_count.to_d)
    end
  end

  def total_rating(player_count = 1)
    [pass_blocking_rating(player_count).to_d * 0.5214.to_d, run_blocking_rating(player_count).to_d * 0.4786.to_d].sum
  end
end
