class Import::Players < ApplicationJob
  require 'csv'


  def perform
    players, contracts, archetypes = get_values

    Player.delete_all
    Player.insert_all(players)

    PlayerContract.delete_all
    PlayerContract.insert_all(contracts)

    PlayerArchetype.delete_all
    PlayerArchetype.insert_all(archetypes)

    nil
  end


  private

  def get_values
    archetype_names = get_archetype_names
    players, contracts, archetypes = [], [], []
    player_id, contract_id, archetype_id = 0, 0, 0


    CSV.foreach(Rails.root.join("players.csv"), headers: true, header_converters: :symbol) do |row|
      next unless row[:contractstatus] == "FreeAgent" || (row[:contractstatus] == "Signed" && row[:teamindex].to_i < 32)

      player_id += 1
      player_archetypes = []
      cap_hit, cap_savings, cap_penalty = 0, 0, 0

      (0..7).each do |index|
        salary = (row["contractsalary#{index}".to_sym].to_i * 10_000)
        bonus = (row["contractbonus#{index}".to_sym].to_i * 10_000)
        next if (salary + bonus).zero?

        contract_id += 1

        if row[:contractyear].to_i == index
          cap_hit = (salary + bonus)
          cap_savings = (salary - bonus)
        elsif row[:contractyear].to_i < index
          cap_penalty += bonus
        end

        contracts << {
          id: contract_id,
          player_id: player_id,
          contract_year: (index + 1),
          cap_hit: (salary + bonus),
          salary: salary,
          bonus: bonus,
        }
      end

      (0..3).each do |index|
        next if row["overallgrade#{index}".to_sym].to_i.zero?
        archetype_name = archetype_names[row[:position]][index]
        next if archetype_name.nil?

        archetype_id += 1
        archetype = {
          id: archetype_id,
          player_id: player_id,
          name: archetype_name,
          overall_rating: row["overallgrade#{index}".to_sym].to_i,
        }

        player_archetypes << archetype
        archetypes << archetype
      end

      role = get_role(row[:position], row[:weight].to_i, player_archetypes)

      players << {
        id: player_id,
        team_id: row[:teamindex].to_i < 32 ? (row[:teamindex].to_i + 1) : nil,
        name: [row[:firstname], row[:lastname]].compact.join(" "),
        position: row[:position],
        role: role[:name],
        style: role[:style],
        development_trait: row[:traitdevelopment],
        contract_status: row[:contractstatus],
        injury_status: row[:injurystatus],
        age: row[:age].to_i,
        draft_round: row[:plyr_draftround].to_i,
        draft_pick: row[:plyr_draftpick].to_i,
        year_drafted: (2019 + row[:yeardrafted].to_i),
        years_pro: row[:yearspro].to_i,
        contract_length: row[:contractlength].to_i,
        contract_year: (row[:contractyear].to_i + 1),
        contract_years_left: (row[:contractlength].to_i - row[:contractyear].to_i),
        overall_rating: row[:overallrating].to_i,
        rating: role[:rating],
        value: role[:value],
        cap_hit: cap_hit,
        cap_savings: cap_savings,
        cap_penalty: cap_penalty,
      }
    end

    [players, contracts, archetypes]
  end

  def get_role(position, weight, archetypes) # :TODO:
    role_names = (get_role_names[position] || [position])
    role = nil

    role_names.each do |role_name|
      if role_name == "QB"
        role = Calculate::Quarterback.new(archetypes: archetypes).role
      elsif role_name == "HB"
        role = Calculate::Runningback.new(archetypes: archetypes).role
      elsif role_name == "FB"
        role = Calculate::Fullback.new(archetypes: archetypes).role
      elsif role_name == "WR"
        role = Calculate::WideReceiver.new(archetypes: archetypes).role
      elsif role_name == "TE"
        role = Calculate::TightEnd.new(archetypes: archetypes).role
      elsif role_name == "OT"
        role = Calculate::OffensiveTackle.new(archetypes: archetypes).role
      elsif role_name == "IOL"
        role = Calculate::InteriorOffensiveLine.new(archetypes: archetypes).role
      elsif role_name == "ED" && weight < 120
        role = Calculate::Edge.new(archetypes: archetypes).role
      elsif role_name == "IDL"
        role ||= Calculate::InteriorDefensiveLine.new(archetypes: archetypes).role
      elsif role_name == "LB"
        role ||= Calculate::Linebacker.new(archetypes: archetypes).role
      elsif role_name == "CB"
        role = Calculate::Cornerback.new(archetypes: archetypes).role
      elsif role_name == "S"
        role = Calculate::Safety.new(archetypes: archetypes).role
      elsif role_name == "K"
        role = Calculate::Kicker.new(archetypes: archetypes).role
      elsif role_name == "P"
        role = Calculate::Punter.new(archetypes: archetypes).role
      end
    end

    (role || {})
  end
end