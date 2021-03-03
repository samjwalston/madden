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
    archetype = get_roles(1)

    @role = {
      name: role_name,
      style: archetype[:name],
      rating: rating,
      value: value
    }
  end


  private

  def get_roles(player_count, *styles)
    if !@players.empty?
      players = @players.map do |p|
        archetypes = (styles.empty? ? p.archetypes : p.archetypes.to_a.find_all{|a| a.name.in?(styles)})
        archetype = archetypes.sort{|a, b| b.overall_rating <=> a.overall_rating}.first
        archetype.attributes.symbolize_keys
      end.sort{|a, b| [b[:overall_rating], (roles.index(b[:name]) || -1)] <=> [a[:overall_rating], (roles.index(a[:name]) || -1)]}

      player_count == 1 ? players.first : players[0...player_count]
    elsif !@archetypes.empty?
      archetypes = (styles.empty? ? @archetypes : @archetypes.to_a.find_all{|a| a[:name].in?(styles)})
      archetypes.sort{|a, b| [b[:overall_rating], (roles.index(b[:name]) || -1)] <=> [a[:overall_rating], (roles.index(a[:name]) || -1)]}.first
    else
      nil
    end
  end
end
