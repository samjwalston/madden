class Import::Prospects < ApplicationService
  require 'csv'

  def call
    ::Prospect.delete_all
    ::Grade.delete_all

    prospects, grades = get_values

    prospects.each_slice(100){|values| ::Prospect.create(values)}
    grades.each_slice(100){|values| ::Grade.create(values)}

    nil
  end


  private

  def get_values
    prospects = []
    grades = []

    letter_grades = get_letter_grades
    archetype_names = get_archetype_names
    role_values = get_role_values

    prospect_id = 0
    grade_id = 0

    CSV.foreach(Rails.root.join("board.csv"), {headers: true, header_converters: :symbol}) do |row|
      next if row[:position].nil?

      prospect_id += 1
      archetypes = row.to_h.keys.dup.keep_if{|k| k.to_s.starts_with?([row[:position].downcase, "_"].join)}.map do |archetype|
        archetype_name = archetype_names[row[:position]][archetype.to_s]
        letter_grade = row[archetype]

        {
          name: archetype_name,
          grade: letter_grade,
          rating: letter_grades.index(letter_grade).to_i,
        }
      end

      role = get_role(row[:position], archetypes)
      rating = (archetypes.map{|a| a[:rating]}.sum.to_d / archetypes.size)
      prospect_value = get_prospect_value(role, archetypes, rating)

      archetypes.each do |archetype|
        grade_id += 1

        grades << {
          id: grade_id,
          prospect_id: prospect_id,
          archetype: archetype[:name],
          letter: archetype[:grade],
          rating: archetype[:rating],
          value: role_values[role].index(archetype[:name]),
        }
      end

      prospects << {
        id: prospect_id,
        name: [row[:first_name], row[:last_name]].compact.join(" "),
        first_name: row[:first_name],
        last_name: row[:last_name],
        position: row[:position],
        role: role,
        grade: letter_grades[rating.round],
        age: row[:age].to_i,
        height: row[:height_data].to_i,
        weight: row[:weight].to_i,
        round: row[:projected_draft_rd_data].to_i > 7 ? nil : row[:projected_draft_rd_data].to_i,
        pick: row[:projected_draft_rd_data].to_i > 7 ? nil : row[:projected_draft_pk_data].to_i,
        value: prospect_value
      }
    end

    [prospects, grades]
  end

  def get_letter_grades
    ["F", "D-", "D", "D+", "C-", "C", "C+", "B-", "B", "B+", "A-", "A", "A+"]
  end

  def get_archetype_names
    {
      "QB"=>{"qb_field_general"=>"Field General", "qb_strong_arm"=>"Strong Arm", "qb_west_coast"=>"Improviser", "qb_scrambler"=>"Scrambler"},
      "HB"=>{"hb_power"=>"Power Back", "hb_elusive"=>"Elusive Back", "hb_receiving"=>"Receiving Back"},
      "FB"=>{"fb_blocking"=>"Blocking", "fb_utility"=>"Utility"},
      "WR"=>{"wr_deep_threat"=>"Deep Threat", "wr_posession"=>"Route Runner", "wr_red_zone_threat"=>"Physical", "wr_slot"=>"Slot"},
      "TE"=>{"te_blocking"=>"Blocking", "te_vertical_threat"=>"Vertical Threat", "te_posession"=>"Possession"},
      "LT"=>{"lt_pass_protector"=>"Pass Protector", "lt_power"=>"Power", "lt_agile"=>"Agile"},
      "LG"=>{"lg_pass_protector"=>"Pass Protector", "lg_power"=>"Power", "lg_agile"=>"Agile"},
      "C"=>{"c_pass_protector"=>"Pass Protector", "c_power"=>"Power", "c_agile"=>"Agile"},
      "RG"=>{"rg_pass_protector"=>"Pass Protector", "rg_power"=>"Power", "rg_agile"=>"Agile"},
      "RT"=>{"rt_pass_protector"=>"Pass Protector", "rt_power"=>"Power", "rt_agile"=>"Agile"},
      "LE"=>{"le_speed_rusher"=>"Speed Rusher", "le_power_rusher"=>"Power Rusher", "le_run_stopper"=>"Run Stopper"},
      "RE"=>{"re_speed_rusher"=>"Speed Rusher", "re_power_rusher"=>"Power Rusher", "re_run_stopper"=>"Run Stopper"},
      "DT"=>{"dt_run_stopper"=>"Run Stopper", "dt_speed_rusher"=>"Speed Rusher", "dt_power_rusher"=>"Power Rusher"},
      "LOLB"=>{"lolb_speed_rusher"=>"Speed Rusher", "lolb_power_rusher"=>"Power Rusher", "lolb_pass_coverage"=>"Pass Coverage", "lolb_run_stopper"=>"Run Stopper"},
      "MLB"=>{"mlb_field_general"=>"Field General", "mlb_pass_coverage"=>"Pass Coverage", "mlb_run_stopper"=>"Run Stopper"},
      "ROLB"=>{"rolb_speed_rusher"=>"Speed Rusher", "rolb_power_rusher"=>"Power Rusher", "rolb_pass_coverage"=>"Pass Coverage", "rolb_run_stopper"=>"Run Stopper"},
      "CB"=>{"cb_man"=>"Man to Man", "cb_slot"=>"Slot", "cb_zone"=>"Zone"},
      "FS"=>{"fs_zone"=>"Zone", "fs_hybrid"=>"Hybrid", "fs_run_support"=>"Run Support"},
      "SS"=>{"ss_zone"=>"Zone", "ss_hybrid"=>"Hybrid", "ss_run_support"=>"Run Support"},
      "K"=>{"k_accurate"=>"Accurate", "k_power"=>"Power"},
      "P"=>{"p_accurate"=>"Accurate", "p_power"=>"Power"},
    }
  end

  def get_role_values
    {
      "QB"=>["Scrambler", "Field General", "Improviser", "Strong Arm"],
      "HB"=>["Elusive Back", "Receiving Back", "Power Back"],
      "FB"=>["Blocking", "Utility"],
      "WR"=>["Physical", "Slot", "Deep Threat", "Route Runner"],
      "TE"=>["Blocking", "Possession", "Vertical Threat"],
      "OT"=>["Agile", "Power", "Pass Protector"],
      "IOL"=>["Agile", "Pass Protector", "Power"],
      "EDP"=>["Pass Coverage", "Run Stopper", "Speed Rusher", "Power Rusher"],
      "EDS"=>["Pass Coverage", "Run Stopper", "Power Rusher", "Speed Rusher"],
      "IDL"=>["Speed Rusher", "Run Stopper", "Power Rusher"],
      "OLB"=>["Power Rusher", "Speed Rusher", "Run Stopper", "Pass Coverage"],
      "ILB"=>["Run Stopper", "Pass Coverage", "Field General"],
      "CB"=>["Slot", "Zone", "Man to Man"],
      "FS"=>["Run Support", "Hybrid", "Zone"],
      "SS"=>["Zone", "Run Support", "Hybrid"],
      "K"=>["Power", "Accurate"],
      "P"=>["Power", "Accurate"],
    }
  end

  def get_role(position, archetypes)
    if position.in?(["LT","LG","C","RG","RT"])
      pass_protector = archetypes.detect{|a| a[:name] == "Pass Protector"}
      power = archetypes.detect{|a| a[:name] == "Power"}

      pass_protector[:rating] >= power[:rating] ? "OT" : "IOL"
    elsif position.in?(["LE","RE","DT"])
      max_archetype = archetypes.sort{|a,b| b[:rating] <=> a[:rating]}.first
      speed = archetypes.detect{|a| a[:name] == "Speed Rusher"}
      power = archetypes.detect{|a| a[:name] == "Power Rusher"}

      if speed[:rating] == max_archetype[:rating]
        "EDS"
      elsif power[:rating] == max_archetype[:rating] && (power[:rating] + speed[:rating]) >= ((power[:rating] * 2) - 1)
        "EDP"
      else
        "IDL"
      end
    elsif position.in?(["LOLB","ROLB"])
      max_archetype = archetypes.sort{|a,b| b[:rating] <=> a[:rating]}.first
      speed = archetypes.detect{|a| a[:name] == "Speed Rusher"}
      power = archetypes.detect{|a| a[:name] == "Power Rusher"}

      if speed[:rating] == max_archetype[:rating]
        "EDS"
      elsif power[:rating] == max_archetype[:rating]
        "EDP"
      else
        "OLB"
      end
    elsif position == "MLB"
      field_general = archetypes.detect{|a| a[:name] == "Field General"}
      pass_coverage = archetypes.detect{|a| a[:name] == "Pass Coverage"}

      pass_coverage[:rating] > field_general[:rating] ? "OLB" : "ILB"
    elsif position.in?(["FS","SS"])
      max_archetype = archetypes.sort{|a,b| b[:rating] <=> a[:rating]}.first
      zone = archetypes.detect{|a| a[:name] == "Zone"}

      zone[:rating] == max_archetype[:rating] ? "FS" : "SS"
    else
      position
    end
  end

  def get_prospect_value(role, archetypes, rating)
    if role == "QB"
      max_archetype = archetypes.sort{|a,b| b[:rating] <=> a[:rating]}.first
      strong_arm = archetypes.detect{|a| a[:name] == "Strong Arm"}

      strong_arm[:rating] == max_archetype[:rating] ? (rating + 1.5.to_d).round(2) : (rating + 1.25.to_d).round(2)
    elsif role == "HB"
      max_archetype = archetypes.sort{|a,b| b[:rating] <=> a[:rating]}.first
      power_back = archetypes.detect{|a| a[:name] == "Power Back"}

      power_back[:rating] == max_archetype[:rating] ? (rating - 0.25.to_d).round(2) : (rating - 0.5.to_d).round(2)
    elsif role == "WR"
      max_archetype = archetypes.sort{|a,b| b[:rating] <=> a[:rating]}.first
      route_runner = archetypes.detect{|a| a[:name] == "Route Runner"}
      deep_threat = archetypes.detect{|a| a[:name] == "Deep Threat"}

      if deep_threat[:rating] == max_archetype[:rating] || route_runner[:rating] == max_archetype[:rating]
        (rating + 0.5.to_d).round(2)
      else
        (rating + 0.25.to_d).round(2)
      end
    elsif role == "TE"
      max_archetype = archetypes.sort{|a,b| b[:rating] <=> a[:rating]}.first
      blocking = archetypes.detect{|a| a[:name] == "Blocking"}

      blocking[:rating] == max_archetype[:rating] ? (rating - 0.5.to_d).round(2) : (rating - 0.25.to_d).round(2)
    elsif role == "OT"
      max_archetype = archetypes.sort{|a,b| b[:rating] <=> a[:rating]}.first
      pass_protector = archetypes.detect{|a| a[:name] == "Pass Protector"}

      pass_protector[:rating] == max_archetype[:rating] ? (rating + 0.25.to_d).round(2) : rating.round(2)
    elsif role == "IOL"
      max_archetype = archetypes.sort{|a,b| b[:rating] <=> a[:rating]}.first
      power = archetypes.detect{|a| a[:name] == "Power"}

      power[:rating] == max_archetype[:rating] ? (rating - 0.25.to_d).round(2) : (rating - 0.5.to_d).round(2)
    elsif role.in?(["EDP","EDS"])
      (rating + 0.25.to_d).round(2)
    elsif role == "IDL"
      run_stopper = archetypes.detect{|a| a[:name] == "Run Stopper"}
      power_rusher = archetypes.detect{|a| a[:name] == "Power Rusher"}

      if run_stopper[:rating] > (power_rusher[:rating] + 1)
        (rating - 0.5.to_d).round(2)
      elsif run_stopper[:rating] > power_rusher[:rating]
        (rating - 0.25.to_d).round(2)
      else
        rating.round(2)
      end
    elsif role == "OLB"
      max_archetype = archetypes.sort{|a,b| b[:rating] <=> a[:rating]}.first
      pass_coverage = archetypes.detect{|a| a[:name] == "Pass Coverage"}

      pass_coverage[:rating] == max_archetype[:rating] ? rating.round(2) : (rating - 0.25.to_d).round(2)
    elsif role == "ILB"
      max_archetype = archetypes.sort{|a,b| b[:rating] <=> a[:rating]}.first
      field_general = archetypes.detect{|a| a[:name] == "Field General"}

      field_general[:rating] == max_archetype[:rating] ? (rating + 0.25.to_d).round(2) : rating.round(2)
    elsif role == "CB"
      (rating + 0.5.to_d).round(2)
    elsif role.in?(["FS","SS"])
      rating.round(2)
    else
      (rating - 2.to_d).round(2)
    end
  end
end
