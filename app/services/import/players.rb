class Import::Players < ApplicationService
  require 'csv'

  def call
    ::Player.delete_all
    ::Contract.delete_all
    ::Archetype.delete_all

    players, contracts, archetypes = get_values

    players.each_slice(100){|values| ::Player.create(values)}
    contracts.each_slice(100){|values| ::Contract.create(values)}
    archetypes.each_slice(100){|values| ::Archetype.create(values)}

    nil
  end


  private

  def get_values
    players = []
    contracts = []
    archetypes = []
    archetype_names = get_archetype_names

    player_id = 0
    contract_id = 0
    archetype_id = 0

    CSV.foreach(Rails.root.join("players.csv"), {headers: true, header_converters: :symbol}) do |row|
      next unless row[:contractstatus].in?(["Signed", "FreeAgent"])

      player_id += 1
      cap_hit = 0
      cap_savings = 0
      cap_penalty = 0

      (0..7).each do |index|
        next if row["contractsalary#{index}".to_sym].to_i.zero?
        contract_id += 1

        if row[:contractyear].to_i == index
          cap_hit = ((row["contractsalary#{index}".to_sym].to_i + row["contractbonus#{index}".to_sym].to_i) * 10_000)
          cap_savings = ((row["contractsalary#{index}".to_sym].to_i - row["contractbonus#{index}".to_sym].to_i) * 10_000)
        elsif row[:contractyear].to_i < index
          cap_penalty += (row["contractbonus#{index}".to_sym].to_i * 10_000)
        end

        contracts << {
          id: contract_id,
          player_id: player_id,
          contract_year: (index + 1),
          salary: (row["contractsalary#{index}".to_sym].to_i * 10_000),
          bonus: (row["contractbonus#{index}".to_sym].to_i * 10_000),
        }
      end

      (0..3).each do |index|
        next if row["overallgrade#{index}".to_sym].to_i.zero?
        archetype_id += 1

        archetypes << {
          id: archetype_id,
          player_id: player_id,
          name: archetype_names[row[:position]][index],
          overall_rating: row["overallgrade#{index}".to_sym].to_i,
        }
      end

      players << {
        id: player_id,
        team_id: row[:teamindex].to_i < 32 ? (row[:teamindex].to_i + 1) : nil,
        name: [row[:firstname], row[:lastname]].compact.join(" "),
        first_name: row[:firstname],
        last_name: row[:lastname],
        position: row[:position],
        injury_status: row[:injurystatus],
        development_trait: row[:traitdevelopment],
        age: row[:age].to_i,
        overall_rating: row[:overallrating].to_i,
        draft_round: row[:plyr_draftround].to_i,
        draft_pick: row[:plyr_draftpick].to_i,
        year_drafted: (2019 + row[:yeardrafted].to_i),
        contract_length: row[:contractlength].to_i,
        contract_year: (row[:contractyear].to_i + 1),
        contract_years_left: (row[:contractlength].to_i - row[:contractyear].to_i),
        cap_hit: cap_hit,
        cap_savings: cap_savings,
        cap_penalty: cap_penalty,
        is_injured_reserve: (row[:isinjuredreserve] == "TRUE"),
      }
    end

    [players, contracts, archetypes]
  end

  def get_archetype_names
    {
      "QB"=>["Field General", "Strong Arm", "Improviser", "Scrambler"],
      "HB"=>["Power Back", "Elusive Back", "Receiving Back"],
      "FB"=>["Blocking", "Utility"],
      "WR"=>["Deep Threat", "Route Runner", "Physical", "Slot"],
      "TE"=>["Blocking", "Vertical Threat", "Possession"],
      "LT"=>["Pass Protector", "Power", "Agile"],
      "LG"=>["Pass Protector", "Power", "Agile"],
      "C"=>["Pass Protector", "Power", "Agile"],
      "RG"=>["Pass Protector", "Power", "Agile"],
      "RT"=>["Pass Protector", "Power", "Agile"],
      "LE"=>["Speed Rusher", "Power Rusher", "Run Stopper"],
      "RE"=>["Speed Rusher", "Power Rusher", "Run Stopper"],
      "DT"=>["Run Stopper", "Speed Rusher", "Power Rusher"],
      "LOLB"=>["Speed Rusher", "Power Rusher", "Pass Coverage", "Run Stopper"],
      "MLB"=>["Field General", "Pass Coverage", "Run Stopper"],
      "ROLB"=>["Speed Rusher", "Power Rusher", "Pass Coverage", "Run Stopper"],
      "CB"=>["Man to Man", "Slot", "Zone"],
      "FS"=>["Zone", "Hybrid", "Run Support"],
      "SS"=>["Zone", "Hybrid", "Run Support"],
      "K"=>["Accurate", "Power"],
      "P"=>["Accurate", "Power"],
    }
  end
end
