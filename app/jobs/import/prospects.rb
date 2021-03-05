class Import::Prospects < Import::Job
  def perform(draft_year)
    prospects, archetypes = get_values(draft_year)

    Prospect.delete_all
    Prospect.insert_all(prospects)

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

        archetype_id += 1
        archetype = {
          id: archetype_id,
          prospect_id: prospect_id,
          name: archetype_name,
          grade: get_letter_grade(rating),
        }

        prospect_archetypes << archetype
        archetypes << archetype
      end

      role = get_role(row[:position], row[:weight].to_i, prospect_archetypes)
      value = get_value(role[:value])
      age = row[:age].to_i

      if age == 20
        value = (value + 1.to_d)
      elsif age == 21
        value = (value + 0.5.to_d)
      elsif age == 23
        value = (value - 0.5.to_d)
      elsif age == 24
        value = (value - 1.to_d)
      end

      if row[:traitdevelopment] == "XFactor"
        dev_trait = "XF"
        value = (value + 7.to_d)
      elsif row[:traitdevelopment] == "Superstar"
        dev_trait = "SS"
        value = (value + 3.to_d)
      elsif row[:traitdevelopment] == "Star"
        dev_trait = "S"
        value = (value + 1.to_d)
      else
        dev_trait = nil
        value = value
      end

      prospects << {
        id: prospect_id,
        name: [row[:firstname], row[:lastname]].compact.join(" "),
        age: age,
        position: row[:position],
        role: role[:name],
        style: role[:style],
        value: (value / 12.to_d).round(3),
        grade: get_letter_grade(role[:rating].floor),
        draft_round: row[:plyr_draftround].to_i > 7 ? nil : row[:plyr_draftround].to_i,
        draft_pick: row[:plyr_draftround].to_i > 7 ? nil : row[:plyr_draftpick].to_i,
        development_trait: dev_trait,
      }
    end

    [prospects, archetypes]
  end

  def get_value(value)
    value * (1 + ((value.to_d - 70.to_d) * 0.01.to_d))
  end
end
