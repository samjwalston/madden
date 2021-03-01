class Calculate::Runningback < Calculate::Position
  PLAYER_VALUE = 0.0227.to_d.freeze
  PLAYER_RUSHING_VALUE = 0.0174.to_d.freeze   # 76.65%
  PLAYER_RECEIVING_VALUE = 0.0053.to_d.freeze # 23.35%

  PROSPECT_VALUE = 0.957.to_d.freeze
  PROSPECT_RUSHING_VALUE = 0.7335.to_d.freeze
  PROSPECT_RECEIVING_VALUE = 0.2665.to_d.freeze


  def rushing_style
    rushing_rating if @rushing_style.nil?
    @rushing_style
  end


  private

  def role_name
    "HB"
  end

  # Team:Rushing(players)
  # Team:Receiving(players)
  def calculate_rating
    if @category == "rushing"
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
      ((rushing_rating * PLAYER_RUSHING_VALUE) + (receiving_rating * PLAYER_RECEIVING_VALUE)).round(4)
    elsif @category == "prospect"
      ((rushing_rating * PROSPECT_RUSHING_VALUE) + (receiving_rating * PROSPECT_RECEIVING_VALUE)).round(4)
    elsif @category == "free_agency"
      ((rushing_rating * PLAYER_RUSHING_VALUE) + (receiving_rating * PLAYER_RECEIVING_VALUE)).round(2).to_f
    end
  end

  def rushing_rating
    archetype = get_roles(1, "Elusive Back", "Power Back")
    @rushing_style = archetype[:name]
    archetype[:overall_rating]
  end

  def receiving_rating
    get_roles(1, "Receiving Back", "Utility")[:overall_rating]
  end
end
