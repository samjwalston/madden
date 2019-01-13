class Import::Team < ApplicationJob
  def perform(data)
    teams = data["leagueTeamInfoList"].map do |team|
      format_data(team, {
        league_id: data["league_id"]
      })
    end

    Team.import(teams, on_duplicate_key_update: :all)
  end


  private

  def format_data(attributes, parameters, details = {})
    attributes.merge(parameters).each do |key, value|
      key = key.to_s.underscore

      if Team.column_names.include?(key)
        details[key.to_sym] = value
      end
    end

    details[:id] = [parameters[:league_id], details[:team_id]].join(":")

    Team.new(details)
  end
end
