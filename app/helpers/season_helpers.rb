module SeasonHelpers
  def import_games(season, week, data)
    games = data.map.with_index do |game, index|
      {
        id: [season, week, (index + 1)].join(":"),
        season: season,
        week: week,
        slot: (index + 1),
        home_team: game.home_team,
        home_rating: game.home_rating,
        away_team: game.away_team,
        away_rating: game.away_rating,
        line: line,
      }
    end

    Game.insert_all(games)

    nil
  end
end
