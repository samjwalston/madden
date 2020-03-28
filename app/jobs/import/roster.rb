class Import::Roster < ApplicationJob
  def perform(data)
    players = data["rosterInfoList"].map do |player|
      format_data(player, {team_id: data["team_id"]})
    end

    ::Player.import(players, on_duplicate_key_update: :all)
    Import::PlayerArchetypes.call(players)
  end


  private

  def format_data(attributes, parameters)
    details = {id: attributes["rosterId"]}

    attributes.merge(parameters).each do |key, value|
      key = key.to_s.underscore

      if ::Player.column_names.include?(key)
        details[key.to_sym] = value
      end
    end

    ::Player.new(details)
  end
end
