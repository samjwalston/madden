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

  def format_data(attributes, parameters, details = {})
    attributes.merge(parameters).each do |key, value|
      key = key.to_s.underscore

      if Player.column_names.include?(key)
        details[key.to_sym] = value
      end
    end

    details[:player_id] = attributes["rosterId"]
    details[:id] = [parameters[:league_id], details[:player_id]].join(":")

    Player.new(details)
  end
end
