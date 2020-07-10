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

      archetypes.each do |archetype|
        grade_id += 1

        grades << {
          id: grade_id,
          prospect_id: prospect_id,
          archetype: archetype[:name],
          letter: archetype[:grade],
          rating: archetype[:rating],
        }
      end

      role = get_role(row[:position], row[:weight], archetypes)

      prospects << {
        id: prospect_id,
        name: [row[:first_name], row[:last_name]].compact.join(" "),
        age: row[:age].to_i,
        position: row[:position],
        role: role[:name],
        style: role[:style],
        value: role[:value],
        grade: letter_grades[role[:rating].to_i],
        draft_round: row[:projected_draft_rd_data].to_i > 7 ? nil : row[:projected_draft_rd_data].to_i,
        draft_pick: row[:projected_draft_rd_data].to_i > 7 ? nil : row[:projected_draft_pk_data].to_i
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

  def get_category_names
    {
      "QB"=>["Passer"],
      "HB"=>["Runner", "Receiver"],
      "FB"=>["Blocker"],
      "WR"=>["Outside Receiver", "Slot Receiver"],
      "TE"=>["Receiver", "Blocker"],
      "LT"=>["Pass Blocker", "Run Blocker"],
      "LG"=>["Pass Blocker", "Run Blocker"],
      "C"=>["Pass Blocker", "Run Blocker"],
      "RG"=>["Pass Blocker", "Run Blocker"],
      "RT"=>["Pass Blocker", "Run Blocker"],
      "LE"=>["Edge Rusher", "Interior Rusher", "Run Stopper"],
      "RE"=>["Edge Rusher", "Interior Rusher", "Run Stopper"],
      "DT"=>["Edge Rusher", "Interior Rusher", "Run Stopper"],
      "LOLB"=>["Edge Rusher", "Pass Coverage", "Run Stopper"],
      "MLB"=>["Pass Coverage", "Run Stopper"],
      "ROLB"=>["Edge Rusher", "Pass Coverage", "Run Stopper"],
      "CB"=>["Outside Coverage", "Slot Coverage"],
      "FS"=>["Pass Coverage", "Run Stopper"],
      "SS"=>["Pass Coverage", "Run Stopper"],
      "K"=>["Kicker"],
      "P"=>["Kicker"],
    }
  end

  def get_role_names
    {
      "LT"=>["OT", "IOL"],
      "LG"=>["OT", "IOL"],
      "C"=>["OT", "IOL"],
      "RG"=>["OT", "IOL"],
      "RT"=>["OT", "IOL"],
      "LE"=>["EDGE", "IDL"],
      "RE"=>["EDGE", "IDL"],
      "DT"=>["EDGE", "IDL"],
      "LOLB"=>["EDGE", "LB"],
      "MLB"=>["LB"],
      "ROLB"=>["EDGE", "LB"],
      "FS"=>["S"],
      "SS"=>["S"],
    }
  end

  def get_role(position, weight, archetypes)
    categories = get_categories(position, weight, archetypes)
    roles = get_roles(position, categories, archetypes)

    if position.in?(["LOLB","ROLB"])
      edge = roles.detect{|a| a[:name] == "EDGE"}
      linebacker = roles.detect{|a| a[:name] == "LB"}

      edge[:rating] >= linebacker[:rating] ? edge : linebacker
    else
      roles.first
    end
  end

  def get_categories(position, weight, archetypes)
    position_categories = get_category_names
    category_names = position_categories[position]
    categories = []

    category_names.each do |category_name|
      rating = if position == "QB"
        [
          archetypes.detect{|a| a[:name] == "Field General"}.to_h[:rating].to_d * 0.3.to_d,
          archetypes.detect{|a| a[:name] == "Strong Arm"}.to_h[:rating].to_d * 0.25.to_d,
          archetypes.detect{|a| a[:name] == "Improviser"}.to_h[:rating].to_d * 0.25.to_d,
          archetypes.detect{|a| a[:name] == "Scrambler"}.to_h[:rating].to_d * 0.2.to_d
        ].sum
      elsif position == "HB"
        if category_name == "Runner"
          [
            archetypes.detect{|a| a[:name] == "Elusive Back"}.to_h[:rating].to_d,
            archetypes.detect{|a| a[:name] == "Power Back"}.to_h[:rating].to_d
          ].max
        else
          archetypes.detect{|a| a[:name] == "Receiving Back"}.to_h[:rating].to_d
        end
      elsif position == "FB"
        [
          archetypes.detect{|a| a[:name] == "Blocking"}.to_h[:rating].to_d * 0.75.to_d,
          archetypes.detect{|a| a[:name] == "Utility"}.to_h[:rating].to_d * 0.25.to_d
        ].sum
      elsif position == "WR"
        if category_name == "Outside Receiver"
          [
            archetypes.detect{|a| a[:name] == "Route Runner"}.to_h[:rating].to_d * 0.75.to_d,
            archetypes.detect{|a| a[:name] == "Deep Threat"}.to_h[:rating].to_d * 0.25.to_d
          ].sum
        else
          [
            archetypes.detect{|a| a[:name] == "Slot"}.to_h[:rating].to_d * 0.75.to_d,
            archetypes.detect{|a| a[:name] == "Physical"}.to_h[:rating].to_d * 0.25.to_d
          ].sum
        end
      elsif position == "TE"
        if category_name == "Receiver"
          [
            archetypes.detect{|a| a[:name] == "Possession"}.to_h[:rating].to_d * 0.5.to_d,
            archetypes.detect{|a| a[:name] == "Vertical Threat"}.to_h[:rating].to_d * 0.5.to_d
          ].sum
        else
          archetypes.detect{|a| a[:name] == "Blocking"}.to_h[:rating].to_d
        end
      elsif position.in?(["LT", "LG", "C", "RG", "RT"])
        if category_name == "Run Blocker"
          [
            archetypes.detect{|a| a[:name] == "Power"}.to_h[:rating].to_d,
            archetypes.detect{|a| a[:name] == "Agile"}.to_h[:rating].to_d
          ].max
        else
          archetypes.detect{|a| a[:name] == "Pass Protector"}.to_h[:rating].to_d
        end
      elsif position.in?(["LE", "RE", "DT"])
        if category_name == "Edge Rusher"
          if weight.to_i < 280
            [
              archetypes.detect{|a| a[:name] == "Power Rusher"}.to_h[:rating].to_d * 0.5.to_d,
              archetypes.detect{|a| a[:name] == "Speed Rusher"}.to_h[:rating].to_d * 0.5.to_d
            ].sum
          else
            0
          end
        elsif category_name == "Interior Rusher"
          if weight.to_i >= 280
            [
              archetypes.detect{|a| a[:name] == "Power Rusher"}.to_h[:rating].to_d * 0.75.to_d,
              archetypes.detect{|a| a[:name] == "Speed Rusher"}.to_h[:rating].to_d * 0.25.to_d
            ].sum
          else
            0
          end
        else
          archetypes.detect{|a| a[:name] == "Run Stopper"}.to_h[:rating].to_d
        end
      elsif position.in?(["LOLB", "ROLB"])
        if category_name == "Edge Rusher"
          [
            archetypes.detect{|a| a[:name] == "Power Rusher"}.to_h[:rating].to_d * 0.5.to_d,
            archetypes.detect{|a| a[:name] == "Speed Rusher"}.to_h[:rating].to_d * 0.5.to_d
          ].sum
        elsif category_name == "Pass Coverage"
          archetypes.detect{|a| a[:name] == "Pass Coverage"}.to_h[:rating].to_d
        else
          archetypes.detect{|a| a[:name] == "Run Stopper"}.to_h[:rating].to_d
        end
      elsif position == "MLB"
        if category_name == "Pass Coverage"
          [
            archetypes.detect{|a| a[:name] == "Pass Coverage"}.to_h[:rating].to_d * 0.75.to_d,
            archetypes.detect{|a| a[:name] == "Field General"}.to_h[:rating].to_d * 0.25.to_d
          ].sum
        else
          [
            archetypes.detect{|a| a[:name] == "Run Stopper"}.to_h[:rating].to_d * 0.75.to_d,
            archetypes.detect{|a| a[:name] == "Field General"}.to_h[:rating].to_d * 0.25.to_d
          ].sum
        end
      elsif position == "CB"
        if category_name == "Outside Coverage"
          [
            archetypes.detect{|a| a[:name] == "Man to Man"}.to_h[:rating].to_d * 0.5.to_d,
            archetypes.detect{|a| a[:name] == "Zone"}.to_h[:rating].to_d * 0.5.to_d
          ].sum
        else
          [
            archetypes.detect{|a| a[:name] == "Slot"}.to_h[:rating].to_d * 0.6.to_d,
            archetypes.detect{|a| a[:name] == "Man to Man"}.to_h[:rating].to_d * 0.2.to_d,
            archetypes.detect{|a| a[:name] == "Zone"}.to_h[:rating].to_d * 0.2.to_d
          ].sum
        end
      elsif position.in?(["FS", "SS"])
        if category_name == "Pass Coverage"
          [
            archetypes.detect{|a| a[:name] == "Zone"}.to_h[:rating].to_d * 0.5.to_d,
            archetypes.detect{|a| a[:name] == "Hybrid"}.to_h[:rating].to_d * 0.5.to_d
          ].sum
        else
          [
            archetypes.detect{|a| a[:name] == "Run Support"}.to_h[:rating].to_d * 0.5.to_d,
            archetypes.detect{|a| a[:name] == "Hybrid"}.to_h[:rating].to_d * 0.5.to_d
          ].sum
        end
      elsif position == "K"
        [
          archetypes.detect{|a| a[:name] == "Accurate"}.to_h[:rating].to_d * 0.75.to_d,
          archetypes.detect{|a| a[:name] == "Power"}.to_h[:rating].to_d * 0.25.to_d
        ].sum
      elsif position == "P"
        [
          archetypes.detect{|a| a[:name] == "Accurate"}.to_h[:rating].to_d * 0.5.to_d,
          archetypes.detect{|a| a[:name] == "Power"}.to_h[:rating].to_d * 0.5.to_d
        ].sum
      else
        0
      end

      categories << {name: category_name, rating: rating.to_i}
    end

    categories
  end

  def get_roles(position, categories, archetypes)
    position_roles = get_role_names
    role_names = (position_roles[position] || [position])
    roles = []

    role_names.each do |role_name|
      rating = 0
      value = 0.to_d
      style_name = ""

      if role_name == "QB"
        category = categories.first
        pocket_rating = [
          archetypes.detect{|a| a[:name] == "Field General"}.to_h[:rating].to_d,
          archetypes.detect{|a| a[:name] == "Strong Arm"}.to_h[:rating].to_d
        ].sum
        mobile_rating = [
          archetypes.detect{|a| a[:name] == "Improviser"}.to_h[:rating].to_d,
          archetypes.detect{|a| a[:name] == "Scrambler"}.to_h[:rating].to_d
        ].sum

        rating = category[:rating]
        value = (category[:rating].to_d * 1.0.to_d).round(2)
        style_name = (pocket_rating >= mobile_rating ? "Pocket" : "Mobile")
      elsif role_name == "HB"
        archetype = archetypes.sort{|a,b| b[:rating] <=> a[:rating]}.first

        rating = archetype[:rating]
        value = (archetype[:rating].to_d * 0.775.to_d).round(2)
        style_name = (archetype[:name].split(" ").first)
      elsif role_name == "FB"
        category = categories.first
        archetype = archetypes.sort{|a,b| b[:rating] <=> a[:rating]}.first

        rating = category[:rating]
        value = (category[:rating].to_d * 0.582.to_d).round(2)
        style_name = archetype[:name]
      elsif role_name == "WR"
        outside = categories.detect{|a| a[:name] == "Outside Receiver"}.to_h[:rating].to_d
        slot = categories.detect{|a| a[:name] == "Slot Receiver"}.to_h[:rating].to_d

        if outside >= slot
          rating = outside
          value = (outside.to_d * 0.834.to_d).round(2)
          style_name = "Outside"
        else
          rating = slot
          value = (slot.to_d * 0.781.to_d).round(2)
          style_name = "Slot"
        end
      elsif role_name == "TE"
        receiver = categories.detect{|a| a[:name] == "Receiver"}.to_h[:rating].to_d
        blocker = categories.detect{|a| a[:name] == "Blocker"}.to_h[:rating].to_d

        if receiver >= blocker
          rating = receiver
          value = (receiver.to_d * 0.777.to_d).round(2)
          style_name = "Receiver"
        else
          rating = blocker
          value = (blocker.to_d * 0.686.to_d).round(2)
          style_name = "Blocking"
        end
      elsif role_name == "OT"
        pass = categories.detect{|a| a[:name] == "Pass Blocker"}.to_h[:rating].to_d
        run = categories.detect{|a| a[:name] == "Run Blocker"}.to_h[:rating].to_d

        if pass >= run
          rating = pass
          value = (pass.to_d * 0.776.to_d).round(2)
          style_name = "Pass Protector"
        end
      elsif role_name == "IOL"
        pass = categories.detect{|a| a[:name] == "Pass Blocker"}.to_h[:rating].to_d
        run = categories.detect{|a| a[:name] == "Run Blocker"}.to_h[:rating].to_d

        if run >= pass
          power = archetypes.detect{|a| a[:name] == "Power"}.to_h[:rating].to_d
          agile = archetypes.detect{|a| a[:name] == "Agile"}.to_h[:rating].to_d

          rating = run
          value = (run.to_d * 0.694.to_d).round(2)
          style_name = (power >= agile ? "Power" : "Agile")
        end
      elsif role_name == "EDGE"
        category = categories.detect{|a| a[:name] == "Edge Rusher"}

        unless category[:rating].zero?
          power = archetypes.detect{|a| a[:name] == "Power Rusher"}.to_h[:rating].to_d
          speed = archetypes.detect{|a| a[:name] == "Speed Rusher"}.to_h[:rating].to_d

          rating = category[:rating]
          value = (category[:rating].to_d * 0.81.to_d).round(2) # On this value
          style_name = (power >= speed ? "Power" : "Speed")
        end
      elsif role_name == "IDL"
        rusher = categories.detect{|a| a[:name] == "Interior Rusher"}.to_h[:rating].to_d

        unless rusher.zero?
          run = categories.detect{|a| a[:name] == "Run Stopper"}.to_h[:rating].to_d

          if rusher > run
            rating = rusher
            value = (rusher.to_d * 0.75.to_d).round(2)
            style_name = "Pass Rusher"
          else
            rating = run
            value = (run.to_d * 0.713.to_d).round(2)
            style_name = "Run Stopper"
          end
        end
      elsif role_name == "LB"
        run = categories.detect{|a| a[:name] == "Run Stopper"}.to_h[:rating].to_d
        pass = categories.detect{|a| a[:name] == "Pass Coverage"}.to_h[:rating].to_d
        score = ([run, pass].sum / 2.to_d).floor.to_i

        rating = score
        value = (score.to_d * 0.73.to_d).round(2)
        style_name = (pass > run ? "Outside" : "Inside")
      elsif role_name == "CB"
        outside = categories.detect{|a| a[:name] == "Outside Coverage"}.to_h[:rating].to_d
        slot = categories.detect{|a| a[:name] == "Slot Coverage"}.to_h[:rating].to_d

        if outside >= slot
          rating = outside
          value = (outside.to_d * 0.821.to_d).round(2)
          style_name = "Outside"
        else
          rating = slot
          value = (slot.to_d * 0.821.to_d).round(2)
          style_name = "Slot"
        end
      elsif role_name == "S"
        pass = categories.detect{|a| a[:name] == "Pass Coverage"}.to_h[:rating].to_d
        run = categories.detect{|a| a[:name] == "Run Stopper"}.to_h[:rating].to_d

        if pass >= run
          rating = pass
          value = (pass.to_d * 0.783.to_d).round(2)
          style_name = "Free"
        else
          rating = run
          value = (run.to_d * 0.75.to_d).round(2)
          style_name = "Strong"
        end
      elsif role_name == "K"
        category = categories.first
        accurate = archetypes.detect{|a| a[:name] == "Accurate"}.to_h[:rating].to_d
        power = archetypes.detect{|a| a[:name] == "Power"}.to_h[:rating].to_d

        rating = category[:rating]
        value = (category[:rating].to_d * 0.558.to_d).round(2)
        style_name = (accurate >= power ? "Accurate" : "Power")
      elsif role_name == "P"
        category = categories.first
        accurate = archetypes.detect{|a| a[:name] == "Accurate"}.to_h[:rating].to_d
        power = archetypes.detect{|a| a[:name] == "Power"}.to_h[:rating].to_d

        rating = category[:rating]
        value = (category[:rating].to_d * 0.447.to_d).round(2)
        style_name = (accurate >= power ? "Accurate" : "Power")
      end

      unless rating.zero?
        roles << {
          name: role_name,
          style: style_name,
          rating: rating,
          value: value
        }
      end
    end

    roles
  end
end
