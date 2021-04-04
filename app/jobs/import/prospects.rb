class Import::Prospects < Import::Job
  def perform(draft_year)
    prospects, archetypes = get_values(draft_year)

    Prospect.delete_all
    Prospect.insert_all(prospects)


    archetypes.map do |archetype|
      archetype.delete(:overall_rating)
      archetype
    end

    ProspectArchetype.delete_all
    ProspectArchetype.insert_all(archetypes)

    nil
  end


  private

  def get_values(draft_year)
    archetype_names = get_archetype_names
    prospects, archetypes = [], []
    prospect_id, archetype_id = 0, 0

    CSV.foreach(Rails.root.join("players.csv"), headers: true, header_converters: :symbol) do |row|
      next unless row[:contractstatus] == "Draft" && row[:plyr_home_town] == "PLACEHOLDER_#{draft_year}"

      prospect_id += 1
      prospect_archetypes = []

      (0..3).each do |index|
        rating = row["overallgrade#{index}".to_sym].to_i
        next if rating.zero?
        archetype_name = archetype_names[row[:position]][index]
        next if archetype_name.nil?

        grade = get_letter_grade(rating)

        archetype_id += 1
        archetype = {
          id: archetype_id,
          prospect_id: prospect_id,
          overall_rating: rating,
          rating: get_grade_rating(grade),
          name: archetype_name,
          grade: grade,
        }

        prospect_archetypes << archetype
        archetypes << archetype
      end

      role = get_role(row[:position], row[:weight].to_i, prospect_archetypes, "player")
      value = role[:rating].to_d
      value = get_contract_value(role)
      age = row[:age].to_i

      if age == 20
        value += 0.05.to_d
      elsif age == 21
        value += 0.02.to_d
      elsif age == 23
        value -= 0.02.to_d
      elsif age == 24
        value -= 0.05.to_d
      end

      if row[:traitdevelopment] == "XFactor"
        dev_trait = "XF"
        value += 0.5.to_d
      elsif row[:traitdevelopment] == "Superstar"
        dev_trait = "SS"
        value += 0.2.to_d
      elsif row[:traitdevelopment] == "Star"
        dev_trait = "S"
      else
        value -= 0.2.to_d
        dev_trait = nil
      end

      prospects << {
        id: prospect_id,
        name: [row[:firstname], row[:lastname]].compact.join(" "),
        age: age,
        position: row[:position],
        role: role[:name],
        style: role[:style],
        value: [8, value].min.round(3),
        grade: get_letter_grade(role[:rating].floor),
        draft_round: row[:plyr_draftround].to_i > 7 ? nil : row[:plyr_draftround].to_i,
        draft_pick: row[:plyr_draftround].to_i > 7 ? nil : row[:plyr_draftpick].to_i,
        development_trait: dev_trait,
      }
    end

    [prospects, archetypes]
  end

  def get_grade_rating(grade)
    ["F","D","D+","C-","C","C+","B-","B","B+","A-","A","A+"].index(grade)
  end

  def get_contract_value(role)
    value = {
      "QB":  0.02.to_d,
      "HB":  0.048.to_d,
      "FB":  0.17.to_d,
      "WR":  0.04.to_d,
      "TE":  0.049.to_d,
      "OT":  0.042.to_d,
      "IOL": 0.046.to_d,
      "ED":  0.041.to_d,
      "IDL": 0.044.to_d,
      "LB":  0.045.to_d,
      "CB":  0.043.to_d,
      "S":   0.047.to_d,
      "K":   0.22.to_d,
    }[role[:name].to_sym]

    ((role[:rating].to_d * 0.1.to_d) * (1.to_d - value))
  end
end
