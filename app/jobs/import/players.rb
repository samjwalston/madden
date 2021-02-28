module Import
  class Players < ApplicationJob
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


      CSV.foreach(Rails.root.join("players.csv"), {headers: true, header_converters: :symbol}) do |row|
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

          archetype_id += 1
          archetype = {
            id: archetype_id,
            player_id: player_id,
            name: archetype_names[row[:position]][index],
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
      roles = []

      role_names.each do |role_name|
        case role_name
        when "QB"
          roles << get_quarterback_role(archetypes)
        # when "HB"
        #   roles << get_runningback_role(archetypes)
        # when "FB"
        #   roles << get_fullback_role(archetypes)
        # when "WR"
        #   roles << get_receiver_role(archetypes)
        # when "TE"
        #   roles << get_tightend_role(archetypes)
        # when "OT"
        #   roles << get_offensive_tackle_role(archetypes)
        # when "IOL"
        #   roles << get_interior_offensive_line_role(archetypes)
        # when "EDGE"
        #   roles << get_edge_rusher_role(archetypes, position, weight)
        # when "IDL"
        #   roles << get_interior_defensive_line_role(archetypes, weight)
        # when "LB"
        #   roles << get_linebacker_role(archetypes, position, weight)
        # when "CB"
        #   roles << get_cornerback_role(archetypes)
        # when "S"
        #   roles << get_safety_role(archetypes)
        # when "K"
        #   roles << get_kicker_role(archetypes)
        # when "P"
        #   roles << get_punter_role(archetypes)
        end
      end

      player_role = roles.compact.map do |role|
        if role[:rating].zero?
          nil
        else
          role_id += 1
          role.merge({id: role_id, player_id: player_id})
        end
      end.compact.first

      player_role
    end

    def get_quarterback_role(archetypes)
      Calculate::Quarterback.call(archetypes).player_rating
    end

    # def get_runningback_role(archetypes)
    #   Calculate::Runningback.call(archetypes).player_rating
    # end

    # def get_fullback_role(archetypes)
    #   Calculate::Fullback.call(archetypes).player_rating
    # end

    # def get_receiver_role(archetypes)
    #   Calculate::WideReceiver.call(archetypes).player_rating
    # end

    # def get_tightend_role(archetypes)
    #   Calculate::TightEnd.call(archetypes).player_rating
    # end

    # def get_offensive_tackle_role(archetypes)
    #   Calculate::OffensiveTackle.call(archetypes).player_rating
    # end

    # def get_interior_offensive_line_role(archetypes)
    #   Calculate::InteriorOffensiveLine.call(archetypes).player_rating
    # end

    # def get_edge_rusher_role(archetypes, position, weight)
    #   return nil if weight >= 120
    #   Calculate::Edge.call(archetypes, position).player_rating
    # end

    # def get_interior_defensive_line_role(archetypes, weight)
    #   return nil if weight < 120
    #   Calculate::InteriorDefensiveLine.call(archetypes).player_rating
    # end

    # def get_linebacker_role(archetypes, position, weight)
    #   Calculate::Linebacker.call(archetypes, position).player_rating
    # end

    # def get_cornerback_role(archetypes)
    #   Calculate::Cornerback.call(archetypes).player_rating
    # end

    # def get_safety_role(archetypes)
    #   Calculate::Safety.call(archetypes).player_rating
    # end

    # def get_kicker_role(archetypes)
    #   Calculate::Kicker.call(archetypes).player_rating
    # end

    # def get_punter_role(archetypes)
    #   Calculate::Punter.call(archetypes).player_rating
    # end
  end
end
