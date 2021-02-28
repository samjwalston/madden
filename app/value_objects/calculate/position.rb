class Calculate::Position
  def initialize(**params)
    @category = (params[:category] || "player")
    @archetypes = (params[:archetypes] || [])
    @players = (params[:players] || [])
  end

  def rating
    @rating ||= calculate_rating
  end

  def value
    @value ||= calculate_value
  end

  def role
    @role unless @role.nil?
    archetype = get_role

    @role = {
      name: role_name,
      style: archetype[:name],
      rating: archetype[:overall_rating],
      value: calculate_value
    }
  end


  private

  def get_role
    @archetypes.to_a.sort{|a, b| b[:overall_rating] <=> a[:overall_rating]}.first
  end

  def get_roles(player_count, *styles)
    players = @players.map do |p|
      archetypes = (styles.empty? ? p.archetypes : p.archetypes.to_a.find_all{|a| a.name.in?(styles)})
      archetype = archetypes.sort{|a, b| b.overall_rating <=> a.overall_rating}.first
      archetype.attributes.symbolize_keys
    end.sort{|a, b| b[:overall_rating] <=> a[:overall_rating]}

    player_count == 1 ? players.first : players[0...player_count]
  end
end
