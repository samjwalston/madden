class Import::PlayerArchetypes < ApplicationService
  def call(players)
    ratings = []

    players.map do |player|
      ratings.concat(get_ratings(player))
    end

    PlayerArchetype.import(ratings, on_duplicate_key_update: :all)
  end


  private

  def get_ratings(player)
    archetypes = Archetype.where(position: get_positions(player[:position]))

    archetypes.map do |archetype|
      attributes = archetype.attributes.dup.keep_if{|k,v| k.include?("rating") && v > 0}.map{|k,v| [k.to_sym, v.to_d / 100]}.to_h
      rating = attributes.map do |key, value|
        line = (player[key] / get_denominator(archetype.position))
        (player[key] * (line < 1 ? (line * line) : line)) * value
      end.sum.round(2)

      {
        id: [player[:id], archetype.id].join(":"),
        player_id: player[:id],
        archetype_id: archetype.id,
        overall: [99, rating.round].min,
        rating: rating
      }
    end
  end

  def get_positions(position)
    if position.in?(["FB", "TE"])
      ["FB", "TE"]
    elsif position.in?(["LT", "LG", "C", "RG", "RT"])
      ["LT", "LG", "C", "RG", "RT"]
    elsif position.in?(["LE", "RE"])
      ["LE", "RE", "DT", "LOLB", "ROLB"]
    elsif position.in?(["DT"])
      ["LE", "RE", "DT"]
    elsif position.in?(["LOLB", "ROLB"])
      ["LE", "RE", "LOLB", "ROLB"]
    elsif position.in?(["MLB"])
      ["LOLB", "ROLB", "MLB"]
    elsif position.in?(["CB", "FS", "SS"])
      ["CB", "FS", "SS"]
    elsif position.in?(["K", "P"])
      ["K", "P"]
    else
      [position]
    end
  end

  def get_denominator(position)
    case position
    when "QB", "HB", "WR"
      90.to_d
    when "FB", "TE"
      70.to_d
    when "LT", "C", "RT", "LE", "RE", "DT", "MLB", "CB", "K", "P"
      85.to_d
    else
      80.to_d
    end
  end
end
