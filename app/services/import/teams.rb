class Import::Teams < ApplicationService
  require 'csv'

  def call
    ::Team.delete_all
    ::Team.create(values)

    nil
  end


  private

  def values
    records = []

    CSV.foreach(Rails.root.join("teams.csv"), {headers: true, header_converters: :symbol}) do |row|
      next if row[:teamindex].to_i >= 32

      records << {
        id: (row[:teamindex].to_i + 1),
        name: row[:displayname],
        ovrerall_rating: row[:team_ratingovr].to_i,
        offense_rating: row[:team_ratingoff].to_i,
        defense_rating: row[:team_ratingdef].to_i,
        specialteams_rating: row[:team_ratingst].to_i,
        quaterback_rating: row[:team_ratingqb].to_i,
        runningback_rating: row[:team_ratingrb].to_i,
        widereceiver_rating: row[:team_ratingwr].to_i,
        tightend_rating: row[:team_ratingte].to_i,
        offensiveline_rating: row[:team_ratingol].to_i,
        defensiveline_rating: row[:team_ratingdl].to_i,
        linebacker_rating: row[:team_ratinglb].to_i,
        defensiveback_rating: row[:team_ratingdb].to_i,
      }
    end

    records
  end
end
