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
    team_info = get_team_info

    CSV.foreach(Rails.root.join("teams.csv"), {headers: true, header_converters: :symbol}) do |row|
      next if row[:teamindex].to_i >= 32

      records << {
        id: (row[:teamindex].to_i + 1),
        name: row[:displayname],
        conference: team_info[row[:displayname]]["Conference"],
        division: team_info[row[:displayname]]["Division"],
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


  def get_team_info
    {
      "Bears"=>{"Conference"=>"NFC", "Division"=>"North"},
      "Bengals"=>{"Conference"=>"AFC", "Division"=>"North"},
      "Bills"=>{"Conference"=>"AFC", "Division"=>"East"},
      "Broncos"=>{"Conference"=>"AFC", "Division"=>"West"},
      "Browns"=>{"Conference"=>"AFC", "Division"=>"North"},
      "Buccaneers"=>{"Conference"=>"NFC", "Division"=>"South"},
      "Cardinals"=>{"Conference"=>"NFC", "Division"=>"West"},
      "Chargers"=>{"Conference"=>"AFC", "Division"=>"West"},
      "Chiefs"=>{"Conference"=>"AFC", "Division"=>"West"},
      "Colts"=>{"Conference"=>"AFC", "Division"=>"South"},
      "Cowboys"=>{"Conference"=>"NFC", "Division"=>"East"},
      "Dolphins"=>{"Conference"=>"AFC", "Division"=>"East"},
      "Eagles"=>{"Conference"=>"NFC", "Division"=>"East"},
      "Falcons"=>{"Conference"=>"NFC", "Division"=>"South"},
      "49ers"=>{"Conference"=>"NFC", "Division"=>"West"},
      "Giants"=>{"Conference"=>"NFC", "Division"=>"East"},
      "Jaguars"=>{"Conference"=>"AFC", "Division"=>"South"},
      "Jets"=>{"Conference"=>"AFC", "Division"=>"East"},
      "Lions"=>{"Conference"=>"NFC", "Division"=>"North"},
      "Packers"=>{"Conference"=>"NFC", "Division"=>"North"},
      "Panthers"=>{"Conference"=>"NFC", "Division"=>"South"},
      "Patriots"=>{"Conference"=>"AFC", "Division"=>"East"},
      "Raiders"=>{"Conference"=>"AFC", "Division"=>"West"},
      "Rams"=>{"Conference"=>"NFC", "Division"=>"West"},
      "Ravens"=>{"Conference"=>"AFC", "Division"=>"North"},
      "Redskins"=>{"Conference"=>"NFC", "Division"=>"East"},
      "Saints"=>{"Conference"=>"NFC", "Division"=>"South"},
      "Seahawks"=>{"Conference"=>"NFC", "Division"=>"West"},
      "Steelers"=>{"Conference"=>"AFC", "Division"=>"North"},
      "Texans"=>{"Conference"=>"AFC", "Division"=>"South"},
      "Titans"=>{"Conference"=>"AFC", "Division"=>"South"},
      "Vikings"=>{"Conference"=>"NFC", "Division"=>"North"},
    }
  end
end
