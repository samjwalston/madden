class Import::Coaches < Import::Job
  def perform
    coaches = get_values

    Coach.delete_all
    Coach.insert_all(coaches)

    nil
  end


  private

  def get_values
    coaches = []
    coach_id = 0

    CSV.foreach(Rails.root.join("coaches.csv"), headers: true, header_converters: :symbol) do |row|
      next if row[:position] != "HeadCoach" || row[:level].to_i.zero? || row[:contractstatus] == "Retired"
      coach_id += 1

      offense_rating = row[:coach_offense].to_i
      defense_rating = row[:coach_defense].to_i
      specialteams_rating = row[:coach_k].to_i

      overall_rating = [
        offense_rating.to_d * 0.51.to_d,
        defense_rating.to_d * 0.42.to_d,
        specialteams_rating.to_d * 0.07.to_d
      ].sum.round(2)

      coaches << {
        id: coach_id,
        team_id: row[:contractlength].to_i.zero? ? nil : (row[:teamindex].to_i + 1),
        name: [row[:firstname], row[:lastname]].compact.join(" "),
        overall_rating: overall_rating,
        offense_rating: offense_rating,
        defense_rating: defense_rating,
        specialteams_rating: specialteams_rating,
      }
    end

    coaches
  end
end
