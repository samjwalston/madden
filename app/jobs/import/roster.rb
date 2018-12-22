class Import::Roster < ApplicationJob
  def perform(data)
    players = data["rosterInfoList"].map do |player|
      format_data(player, {
        platform: data["platform"],
        league_id: data["league_id"],
        team_id: data["team_id"],
      })
    end

    Player.import(players, on_duplicate_key_update: :all)
  end

  private

  def format_data(attributes, parameters)
    columns = Player.column_names

    details = attributes.merge(parameters).each do |key, value|
      key = key.to_s.underscore
      [key.to_sym, value] if columns.include?(key)
    end.to_h

    details[:player_id] = details.delete(:roster_id)
    details[:id] = [details[:league_id], details[:player_id]].join(":")

    Player.new(details)
  end
end