class ImportDrafts < ApplicationJob
  def perform(min, max = nil)
    numbers = (max.nil? ? (1..min).to_a : (min..max).to_a)

    numbers.each do |draft|
      data = JSON.parse(File.read(Rails.root.join("draft-#{draft}.json")))
      import_players(data, draft)
    end

    nil
  end

  private

  def import_players(teams, draft)
    teams.each do |team_id, team|
      team["roster"].each do |player_id, player|
        attributes = player.map{|k, v| k == "rosterId" ? nil : [k.underscore.to_sym, v]}.compact.to_h

        DraftPlayer.create({
          player_id: player_id,
          team_id: team_id,
          age: attributes[:age],
          clutch_trait: attributes[:clutch_trait],
          dev_trait: attributes[:dev_trait],
          draft_num: draft,
          draft_pick: (attributes[:draft_pick] > 0 ? (attributes[:draft_pick] - 1) : attributes[:draft_pick]),
          draft_round: (attributes[:draft_round] < 64 ? (attributes[:draft_round] - 1) : attributes[:draft_round]),
          intangible_grade: attributes[:intangible_grade],
          physical_grade: attributes[:physical_grade],
          player_best_ovr: attributes[:player_best_ovr],
          player_scheme_ovr: attributes[:player_scheme_ovr],
          production_grade: attributes[:production_grade],
          scheme: attributes[:scheme],
          team_scheme_ovr: attributes[:team_scheme_ovr],
          years_pro: attributes[:years_pro],
          contract_bonus: attributes[:contract_bonus],
          contract_length: attributes[:contract_length],
          contract_salary: attributes[:contract_salary],
          name: [attributes[:first_name], attributes[:last_name]].compact.join(" "),
          position: attributes[:position]
        })
      end
    end
  end
end
