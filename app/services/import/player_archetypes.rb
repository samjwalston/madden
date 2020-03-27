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
    archetypes = Archetype.where(position: player[:position])

    archetypes.map do |archetype|
      attributes = archetype.attributes.dup.keep_if{|k,v| k.include?("rating") && v > 0}.map{|k,v| [k.to_sym, v.to_d / 100]}.to_h
      rating = attributes.map do |key, value|
        line = (player[key] / 90.to_d)
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
end
