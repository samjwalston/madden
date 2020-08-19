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

    players = get_players
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
          rating: letter_grades.index(letter_grade),
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
      trait = get_trait(players, row[:position], row[:first_name], row[:last_name], row[:age])

      age = row[:age].to_i

      value = if age == 20
        role[:value] + 0.5.to_d
      elsif age == 23
        role[:value] - 0.25.to_d
      elsif age == 24
        role[:value] - 0.5.to_d
      else
        role[:value]
      end

      vaue = if trait == "Superstar"
        value + 1.to_d
      elsif trait == "Star"
        value + 0.33.to_d
      end


      prospects << {
        id: prospect_id,
        name: [row[:first_name], row[:last_name]].compact.join(" "),
        age: age,
        position: row[:position],
        role: role[:name],
        style: role[:style],
        value: value.round(2),
        grade: letter_grades[role[:rating].to_i],
        draft_round: row[:projected_draft_rd_data].to_i > 7 ? nil : row[:projected_draft_rd_data].to_i,
        draft_pick: row[:projected_draft_rd_data].to_i > 7 ? nil : row[:projected_draft_pk_data].to_i,
        development_trait: trait,
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
    role_names = (get_role_names[position] || [position])
    roles = []

    role_names.each do |role_name|
      case role_name
      when "QB"
        roles << get_quarterback_role(archetypes)
      when "HB"
        roles << get_runningback_role(archetypes)
      when "FB"
        roles << get_fullback_role(archetypes)
      when "WR"
        roles << get_receiver_role(archetypes)
      when "TE"
        roles << get_tightend_role(archetypes)
      when "OT"
        roles << get_offensive_tackle_role(archetypes)
      when "IOL"
        roles << get_interior_offensive_line_role(archetypes)
      when "EDGE"
        roles << get_edge_rusher_role(archetypes, position, weight)
      when "IDL"
        roles << get_interior_defensive_line_role(archetypes, weight)
      when "LB"
        roles << get_linebacker_role(archetypes, position, weight)
      when "CB"
        roles << get_cornerback_role(archetypes)
      when "S"
        roles << get_safety_role(archetypes)
      when "K"
        roles << get_kicker_role(archetypes)
      when "P"
        roles << get_punter_role(archetypes)
      end
    end

    player_role = roles.compact.map do |role|
      role[:rating].zero? ? nil : role
    end.compact.first

    player_role
  end

  def get_quarterback_role(archetypes)
    role_value = 1.to_d

    field_general = archetypes.detect{|a| a[:name] == "Field General"}.to_h[:rating].to_d
    improviser = archetypes.detect{|a| a[:name] == "Improviser"}.to_h[:rating].to_d
    strong_arm = archetypes.detect{|a| a[:name] == "Strong Arm"}.to_h[:rating].to_d
    scrambler = archetypes.detect{|a| a[:name] == "Scrambler"}.to_h[:rating].to_d
    max_rating = [field_general, improviser, strong_arm].max

    is_balanced = (field_general == max_rating && improviser == max_rating && strong_arm == max_rating)
    is_not_scrambler = (scrambler < max_rating)

    balanced = [field_general * 0.4.to_d, improviser * 0.4.to_d, strong_arm * 0.2.to_d].sum
    pocket = [field_general * 0.6.to_d, strong_arm * 0.4.to_d].sum
    scrambler = [scrambler * 0.6.to_d, improviser * 0.4.to_d].sum


    if is_balanced && is_not_scrambler && balanced >= pocket && balanced >= scrambler
      {name: "QB", style: "Balanced", rating: balanced.round, value: ((balanced * 1.1.to_d) * role_value).round(2)}
    elsif scrambler > pocket
      {name: "QB", style: "Scrambler", rating: scrambler.round, value: (scrambler * role_value).round(2)}
    else
      {name: "QB", style: "Pocket Passer", rating: pocket.round, value: (pocket * role_value).round(2)}
    end
  end

  def get_runningback_role(archetypes)
    role_value = 0.525.to_d

    power = archetypes.detect{|a| a[:name] == "Elusive Back"}.to_h[:rating].to_d
    elusive = archetypes.detect{|a| a[:name] == "Power Back"}.to_h[:rating].to_d
    receiving = archetypes.detect{|a| a[:name] == "Receiving Back"}.to_h[:rating].to_d
    power_or_elusive = [power, elusive].max

    is_balanced = receiving == power_or_elusive
    rating = [power_or_elusive * 0.75.to_d, receiving * 0.25.to_d].sum


    if is_balanced
      {name: "HB", style: "Balanced", rating: rating.round, value: ((rating * 1.05.to_d) * role_value).round(2)}
    elsif receiving > power_or_elusive
      {name: "HB", style: "Receiver", rating: rating.round, value: (rating * role_value).round(2)}
    elsif elusive > power
      {name: "HB", style: "Elusive", rating: rating.round, value: (rating * role_value).round(2)}
    else
      {name: "HB", style: "Power", rating: rating.round, value: (rating * role_value).round(2)}
    end
  end

  def get_fullback_role(archetypes)
    role_value = 0.325.to_d

    utility = archetypes.detect{|a| a[:name] == "Utility"}.to_h[:rating].to_d
    blocking = archetypes.detect{|a| a[:name] == "Blocking"}.to_h[:rating].to_d

    is_balanced = utility == blocking
    rating = [blocking * 0.6.to_d, utility * 0.4.to_d].sum


    if is_balanced
      {name: "FB", style: "Balanced", rating: rating.round, value: ((rating * 1.01.to_d) * role_value).round(2)}
    elsif utility > blocking
      {name: "FB", style: "Utility", rating: rating.round, value: (rating * role_value).round(2)}
    else
      {name: "FB", style: "Blocker", rating: rating.round, value: (rating * role_value).round(2)}
    end
  end

  def get_receiver_role(archetypes)
    role_value = 0.667.to_d

    route_runner = archetypes.detect{|a| a[:name] == "Route Runner"}.to_h[:rating].to_d
    slot = archetypes.detect{|a| a[:name] == "Slot"}.to_h[:rating].to_d
    deep_threat = archetypes.detect{|a| a[:name] == "Deep Threat"}.to_h[:rating].to_d
    physical = archetypes.detect{|a| a[:name] == "Physical"}.to_h[:rating].to_d
    max_rating = [route_runner, slot, deep_threat].max

    is_balanced = (route_runner == max_rating && slot == max_rating && deep_threat == max_rating)
    is_not_physical = (physical < max_rating)

    balanced = [route_runner * 0.5.to_d, deep_threat * 0.25.to_d, slot * 0.25.to_d].sum
    slot_rating = [slot * 0.75.to_d, route_runner * 0.25.to_d].sum
    deep_rating = [deep_threat * 0.75.to_d, route_runner * 0.25.to_d].sum
    red_zone_rating = [physical * 0.75.to_d, route_runner * 0.25.to_d].sum


    if is_balanced && is_not_physical
      {name: "WR", style: "Balanced", rating: balanced.round, value: ((balanced * 1.01.to_d) * role_value).round(2)}
    elsif red_zone_rating > [route_runner, slot_rating, deep_rating].max
      {name: "WR", style: "Red Zone Threat", rating: red_zone_rating.round, value: (red_zone_rating * role_value).round(2)}
    elsif deep_rating > [route_runner, slot_rating].max
      {name: "WR", style: "Deep Threat", rating: deep_rating.round, value: (deep_rating * role_value).round(2)}
    elsif slot_rating > route_runner
      {name: "WR", style: "Slot", rating: slot_rating.round, value: (slot_rating * role_value).round(2)}
    else
      {name: "WR", style: "Route Runner", rating: route_runner.round, value: (route_runner * role_value).round(2)}
    end
  end

  def get_tightend_role(archetypes)
    role_value = 0.575.to_d

    possession = archetypes.detect{|a| a[:name] == "Possession"}.to_h[:rating].to_d
    vertical = archetypes.detect{|a| a[:name] == "Vertical Threat"}.to_h[:rating].to_d
    blocking = archetypes.detect{|a| a[:name] == "Blocking"}.to_h[:rating].to_d
    max_rating = [possession, vertical, blocking].max

    is_balanced = (possession == max_rating && vertical == max_rating && blocking == max_rating)
    is_not_blocker = (blocking < max_rating)

    receiver = [possession * 0.6.to_d, vertical * 0.4.to_d].sum
    balanced = [receiver * 0.65.to_d, blocking * 0.35.to_d].sum


    if is_balanced && is_not_blocker
      {name: "TE", style: "Balanced", rating: balanced.round, value: ((balanced * 1.1.to_d) * role_value).round(2)}
    elsif blocking > receiver
      {name: "TE", style: "Blocker", rating: blocking.round, value: ((blocking * 0.9.to_d) * role_value).round(2)}
    else
      {name: "TE", style: "Receiver", rating: receiver.round, value: (receiver * role_value).round(2)}
    end
  end

  def get_offensive_tackle_role(archetypes)
    role_value = 0.65.to_d

    pass_protect = archetypes.detect{|a| a[:name] == "Pass Protector"}.to_h[:rating].to_d
    power = archetypes.detect{|a| a[:name] == "Power"}.to_h[:rating].to_d
    agile = archetypes.detect{|a| a[:name] == "Agile"}.to_h[:rating].to_d
    power_or_agile = [power, agile].max

    is_balanced = pass_protect == power_or_agile
    rating = [power_or_agile, pass_protect].max


    if is_balanced
      {name: "OT", style: "Balanced", rating: rating.round, value: ((rating * 1.01.to_d) * role_value).round(2)}
    elsif pass_protect > power_or_agile
      {name: "OT", style: "Pass Protector", rating: pass_protect.round, value: (pass_protect * role_value).round(2)}
    elsif agile > power
      {name: "OT", style: "Finesse", rating: agile.round, value: (agile * role_value).round(2)}
    else
      {name: "OT", style: "Power", rating: power.round, value: (power * role_value).round(2)}
    end
  end

  def get_interior_offensive_line_role(archetypes)
    role_value = 0.367.to_d

    pass_protect = archetypes.detect{|a| a[:name] == "Pass Protector"}.to_h[:rating].to_d
    power = archetypes.detect{|a| a[:name] == "Power"}.to_h[:rating].to_d
    agile = archetypes.detect{|a| a[:name] == "Agile"}.to_h[:rating].to_d
    power_or_agile = [power, agile].max

    is_balanced = pass_protect == power_or_agile
    rating = [power_or_agile, pass_protect].max


    if is_balanced
      {name: "IOL", style: "Balanced", rating: rating.round, value: ((rating * 1.01.to_d) * role_value).round(2)}
    elsif pass_protect > power_or_agile
      {name: "IOL", style: "Pass Protector", rating: pass_protect.round, value: (pass_protect * role_value).round(2)}
    elsif agile > power
      {name: "IOL", style: "Finesse", rating: agile.round, value: (agile * role_value).round(2)}
    else
      {name: "IOL", style: "Power", rating: power.round, value: (power * role_value).round(2)}
    end
  end

  def get_edge_rusher_role(archetypes, position, weight)
    return nil if weight >= 280
    role_value = 0.658.to_d

    power = archetypes.detect{|a| a[:name] == "Power Rusher"}.to_h[:rating].to_d
    speed = archetypes.detect{|a| a[:name] == "Speed Rusher"}.to_h[:rating].to_d

    if position.in?(["LOLB","ROLB"])
      run_stopper = archetypes.detect{|a| a[:name] == "Run Stopper"}.to_h[:rating].to_d
      pass_coverage = archetypes.detect{|a| a[:name] == "Pass Coverage"}.to_h[:rating].to_d
      return nil if [run_stopper, pass_coverage].sum > [power, speed].sum
    end

    is_balanced = power == speed
    rating = if power > speed
      [power * 0.75.to_d, speed * 0.25.to_d].sum
    else
      [speed * 0.75.to_d, power * 0.25.to_d].sum
    end


    if is_balanced
      {name: "EDGE", style: "Balanced", rating: rating.round, value: ((rating * 1.05.to_d) * role_value).round(2)}
    elsif power > speed
      {name: "EDGE", style: "Power Rusher", rating: rating.round, value: (rating * role_value).round(2)}
    else
      {name: "EDGE", style: "Speed Rusher", rating: rating.round, value: (rating * role_value).round(2)}
    end
  end

  def get_interior_defensive_line_role(archetypes, weight)
    return nil if weight < 280
    role_value = 0.35.to_d

    power = archetypes.detect{|a| a[:name] == "Power Rusher"}.to_h[:rating].to_d
    speed = archetypes.detect{|a| a[:name] == "Speed Rusher"}.to_h[:rating].to_d
    run_stopper = archetypes.detect{|a| a[:name] == "Run Stopper"}.to_h[:rating].to_d
    power_or_speed = [power, speed].max

    is_balanced = run_stopper == power_or_speed
    rating = if speed > power
      [speed * 0.5.to_d, power * 0.5.to_d].sum
    else
      [power * 0.9.to_d, speed * 0.1.to_d].sum
    end


    if is_balanced
      {name: "IDL", style: "Balanced", rating: rating.round, value: ((rating * 1.01.to_d) * role_value).round(2)}
    elsif run_stopper > power_or_speed
      {name: "IDL", style: "Run Stopper", rating: run_stopper.round, value: ((run_stopper * 0.95.to_d) * role_value).round(2)}
    elsif speed > power
      {name: "IDL", style: "Speed Rusher", rating: rating.round, value: (rating * role_value).round(2)}
    else
      {name: "IDL", style: "Power Rusher", rating: rating.round, value: (rating * role_value).round(2)}
    end
  end

  def get_linebacker_role(archetypes, position, weight)
    role_value = 0.342.to_d

    run_stopper = archetypes.detect{|a| a[:name] == "Run Stopper"}.to_h[:rating].to_d
    pass_coverage = archetypes.detect{|a| a[:name] == "Pass Coverage"}.to_h[:rating].to_d

    if position.in?(["LOLB","ROLB"])
      power = archetypes.detect{|a| a[:name] == "Power Rusher"}.to_h[:rating].to_d
      speed = archetypes.detect{|a| a[:name] == "Speed Rusher"}.to_h[:rating].to_d
      return nil if [power, speed].sum >= [run_stopper, pass_coverage].sum && weight < 280
    end

    is_balanced = run_stopper == pass_coverage
    rating = [pass_coverage * 0.7.to_d, run_stopper * 0.3.to_d].sum


    if is_balanced
      {name: "LB", style: "Balanced", rating: rating.round, value: ((rating * 1.01.to_d) * role_value).round(2)}
    elsif run_stopper > pass_coverage
      {name: "LB", style: "Run Stopper", rating: rating.round, value: (rating * role_value).round(2)}
    else
      {name: "LB", style: "Coverage", rating: rating.round, value: (rating * role_value).round(2)}
    end
  end

  def get_cornerback_role(archetypes)
    role_value = 0.65.to_d

    man = archetypes.detect{|a| a[:name] == "Man to Man"}.to_h[:rating].to_d
    zone = archetypes.detect{|a| a[:name] == "Zone"}.to_h[:rating].to_d
    slot = archetypes.detect{|a| a[:name] == "Slot"}.to_h[:rating].to_d
    max_rating = [man, zone, slot].max

    is_balanced = (man == max_rating && zone == max_rating && slot == max_rating)
    rating = if slot > zone && slot > man
      [slot * 0.8.to_d, zone * 0.1.to_d, man * 0.1.to_d].sum
    elsif zone > man
      [zone * 0.75.to_d, man * 0.25.to_d].sum
    else
      [man * 0.75.to_d, zone * 0.25.to_d].sum
    end


    if is_balanced
      {name: "CB", style: "Balanced", rating: rating.round, value: ((rating * 1.01.to_d) * role_value).round(2)}
    elsif slot > zone && slot > man
      {name: "CB", style: "Slot", rating: rating.round, value: (rating * role_value).round(2)}
    elsif zone > man
      {name: "CB", style: "Zone", rating: rating.round, value: (rating * role_value).round(2)}
    else
      {name: "CB", style: "Man", rating: rating.round, value: (rating * role_value).round(2)}
    end
  end

  def get_safety_role(archetypes)
    role_value = 0.553.to_d

    coverage = archetypes.detect{|a| a[:name] == "Zone"}.to_h[:rating].to_d
    run_support = archetypes.detect{|a| a[:name] == "Run Support"}.to_h[:rating].to_d

    is_balanced = run_support == coverage
    is_not_run_stopper = (run_support < coverage)
    rating = [coverage * 0.9.to_d, run_support * 0.1.to_d].sum


    if is_balanced && is_not_run_stopper
      {name: "S", style: "Balanced", rating: rating.round, value: ((rating * 1.01.to_d) * role_value).round(2)}
    elsif run_support > coverage
      {name: "S", style: "Run Support", rating: rating.round, value: (rating * role_value).round(2)}
    else
      {name: "S", style: "Coverage", rating: rating.round, value: (rating * role_value).round(2)}
    end
  end

  def get_kicker_role(archetypes)
    role_value = 0.133.to_d

    accurate = archetypes.detect{|a| a[:name] == "Accurate"}.to_h[:rating].to_d
    power = archetypes.detect{|a| a[:name] == "Power"}.to_h[:rating].to_d

    is_balanced = accurate == power
    rating = [accurate * 0.75.to_d, power * 0.25.to_d].sum

    if is_balanced
      {name: "K", style: "Balanced", rating: rating.round, value: ((rating * 1.01.to_d) * role_value).round(2)}
    elsif power > accurate
      {name: "K", style: "Power", rating: rating.round, value: (rating * role_value).round(2)}
    else
      {name: "K", style: "Accurate", rating: rating.round, value: (rating * role_value).round(2)}
    end
  end

  def get_punter_role(archetypes)
    role_value = 0.133.to_d

    accurate = archetypes.detect{|a| a[:name] == "Accurate"}.to_h[:rating].to_d
    power = archetypes.detect{|a| a[:name] == "Power"}.to_h[:rating].to_d

    is_balanced = accurate == power
    rating = [accurate * 0.5.to_d, power * 0.5.to_d].sum

    if is_balanced
      {name: "P", style: "Balanced", rating: rating.round, value: ((rating * 1.01.to_d) * role_value).round(2)}
    elsif power > accurate
      {name: "P", style: "Power", rating: rating.round, value: (rating * role_value).round(2)}
    else
      {name: "P", style: "Accurate", rating: rating.round, value: (rating * role_value).round(2)}
    end
  end

  def get_players
    players = []

    CSV.foreach(Rails.root.join("players.csv"), {headers: true, header_converters: :symbol}) do |row|
      players << {
        position: row[:position],
        first_name: row[:firstname],
        last_name: row[:lastname],
        age: row[:age],
        trait: (row[:traitdevelopment] == "XFactor" ? "Superstar" : row[:traitdevelopment]),
      }
    end

    players
  end

  def get_trait(players, position, first_name, last_name, age)
    trait = "Normal"

    players.each do |player|
      if position == player[:position] && first_name == player[:first_name] && last_name == player[:last_name] && age.to_i == player[:age].to_i
        trait = player[:trait]
        break
      end
    end

    trait
  end
end
