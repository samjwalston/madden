class Calculate::WideReceiver < Calculate::Position
  PLAYER_VALUE = 0.03.to_d.freeze
  PROSPECT_VALUE = 0.975.to_d.freeze


  def receiving_styles
    receiving_rating(3) if @receiving_styles.nil?
    @receiving_styles
  end

  def receiving_scheme_bonus(base_rating, styles)
    categories = format_styles(styles)

    if categories.size == 3
      base_rating * 1.03.to_d
    elsif categories.size == 2
      base_rating * 1.01.to_d
    else
      base_rating
    end
  end


  private

  def role_name
    "WR"
  end

  def roles
    @roles ||= ["Physical", "Slot", "Deep Threat", "Route Runner"]
  end

  # Player(archetypes)
  # Prospect(archetypes)
  # Team:Receiving(players)
  def calculate_rating
    if @category.in?(["player", "prospect"])
      total_rating
    elsif @category == "receiving"
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

  def route_runner_rating(player_count = 1)
    @route_runner_rating unless @route_runner_rating.nil?
    archetypes = get_roles(player_count, "Route Runner")

    if player_count == 1
      @route_runner_rating = archetypes[:overall_rating]
    else
      @route_runner_rating = (archetypes.map do |archetype|
        archetype[:overall_rating]
      end.sum / player_count.to_d)
    end
  end

  def format_styles(styles)
    styles.map do |s|
      if s.in?(["Router Runner", "Physical", "Vertical Threat"])
        0
      elsif s.in?(["Slot", "Possession"])
        1
      elsif s.in?(["Deep Threat"])
        2
      end
    end.uniq
  end

  def total_rating(player_count = 1)
    [receiving_rating(player_count).to_d * 0.75.to_d, route_runner_rating(player_count).to_d * 0.25.to_d].sum
  end
end
