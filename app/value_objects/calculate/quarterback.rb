class Calculate::Quarterback < Calculate::Position
  PLAYER_VALUE = 0.2204.to_d.freeze
  PROSPECT_VALUE = 1.to_d.freeze


  private

  def role_name
    "QB"
  end

  def roles
    @roles ||= ["Scrambler", "Strong Arm", "Improviser", "Field General"]
  end

  # Player(archetypes)
  # Prospect(archetypes)
  # Team:Passing(players)
  def calculate_rating
    passing_rating
  end

  # Player(archetypes)
  # Prospect(archetypes)
  # FreeAgency(players)
  def calculate_value
    if @category == "player"
      (passing_rating * PLAYER_VALUE).round(4)
    elsif @category == "prospect"
      (passing_rating * PROSPECT_VALUE)
    elsif @category == "free_agency"
      (passing_rating * PLAYER_VALUE).round(2).to_f
    end
  end

  def passing_rating
    @passing_rating ||= get_roles(1)[:overall_rating]
  end
end
