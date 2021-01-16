class Import::Coaches < ApplicationService
  require 'csv'

  def call
    ::Coach.delete_all
    ::Coach.create(values)

    nil
  end


  private

  def values
    records = []
    coach_id = 0

    CSV.foreach(Rails.root.join("coaches.csv"), {headers: true, header_converters: :symbol}) do |row|
      name = [row[:firstname], row[:lastname]].compact.join(" ")
      next if row[:teamindex].to_i >= 32 || row[:position] != "HeadCoach" || row[:level].to_i.zero? || name.in?(blacklisted_coaches)
      coach_id += 1

      offense_rating = get_offense_rating(row)
      defense_rating = get_defense_rating(row)
      specialteams_rating = get_specialteams_rating(row)

      overall_rating = [
        offense_rating * 0.4.to_d,
        defense_rating * 0.45.to_d,
        specialteams_rating * 0.15.to_d
      ].sum.round(2)

      records << {
        id: coach_id,
        team_id: (row[:teamindex].to_i + 1),
        name: name,
        overall_rating: overall_rating,
        offense_rating: offense_rating,
        defense_rating: defense_rating,
        specialteams_rating: specialteams_rating,
      }
    end

    records
  end

  def get_offense_rating(coach)
    rating = [
      coach[:coach_knowledge].to_d * 0.13.to_d,
      coach[:coach_qb].to_d * 0.38.to_d,
      coach[:coach_rb].to_d * 0.04.to_d,
      coach[:coach_wr].to_d * 0.23.to_d,
      coach[:coach_ol].to_d * 0.22.to_d
    ].sum

    (100 - ((100 - rating) / 2.to_d)).round(2)
  end

  def get_defense_rating(coach)
    rating = [
      coach[:coach_knowledge].to_d * 0.2.to_d,
      coach[:coach_dl].to_d * 0.3.to_d,
      coach[:coach_lb].to_d * 0.14.to_d,
      coach[:coach_db].to_d * 0.24.to_d,
      coach[:coach_s].to_d * 0.12.to_d
    ].sum

    (100 - ((100 - rating) / 2.to_d)).round(2)
  end

  def get_specialteams_rating(coach)
    rating = [
      coach[:coach_knowledge].to_d * 0.5.to_d,
      coach[:coach_p].to_d * 0.3.to_d,
      coach[:coach_k].to_d * 0.2.to_d,
    ].sum

    (100 - ((100 - rating) / 2.to_d)).round(2)
  end

  def blacklisted_coaches
    [
      "Harold Tibbetts",
      "Marvin Stallard",
      "Victor Ordonez",
      "John Madden",
      "Stephen Crandall",
      "Manuel Fish",
      "William Lavallee",
      "Steve Price",
      "Bryan Steven",
      "Randy Croom",
      "Russell Malony",
    ]
  end
end
