class Calculate::Quarterback < Calculate::Position
  PLAYER_VALUE = 0.2104.to_d.freeze
  PROSPECT_VALUE = 1.to_d.freeze


  private

  def role_name
    "QB"
  end

  def roles
    @roles ||= ["Scrambler", "Strong Arm", "Field General", "Improviser"]
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
    @passing_rating unless @passing_rating.nil?
    improviser = get_roles(1, "Improviser")[:overall_rating]
    field_general = get_roles(1, "Field General")[:overall_rating]
    strong_arm = get_roles(1, "Strong Arm")[:overall_rating]
    scrambler = get_roles(1, "Scrambler")[:overall_rating]

    @passing_rating = [improviser.to_d * 0.4, field_general.to_d * 0.3, strong_arm.to_d * 0.2, scrambler.to_d * 0.1].sum
  end
end
