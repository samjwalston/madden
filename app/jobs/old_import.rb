class OldImport < ApplicationJob
  def perform(filename)
    data = JSON.parse(File.read(Rails.root.join(filename)))
    clear_data
    import_teams(data)
    nil
  end

  private

  def clear_data
    Team.delete_all
    Player.delete_all
  end

  def import_teams(teams)
    teams.each do |id, data|
      attributes = data.map do |key, value|
        if key == "roster" || key == "teamId"
          nil
        else
          [key.underscore.to_sym, value]
        end
      end.compact.to_h

      Team.create(id: id, **attributes)

      import_players(data["roster"], id)
    end
  end

  def import_players(players, team_id)
    players.each do |id, data|
      attributes = data.map do |key, value|
        if key == "rosterId"
          nil
        else
          [key.underscore.to_sym, value]
        end
      end.compact.to_h

      Player.create(id: id, team_id: team_id, **attributes)
    end
  end
end
