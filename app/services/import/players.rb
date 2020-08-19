class Import::Players < ApplicationService
  require 'csv'

  def call
    ::Player.delete_all
    ::Contract.delete_all
    ::Archetype.delete_all
    ::Role.delete_all

    players, contracts, archetypes, roles = get_values

    players.each_slice(100){|values| ::Player.create(values)}
    contracts.each_slice(100){|values| ::Contract.create(values)}
    archetypes.each_slice(100){|values| ::Archetype.create(values)}
    roles.each_slice(100){|values| ::Role.create(values)}

    nil
  end


  private

  def get_values
    players = []
    contracts = []
    archetypes = []
    roles = []
    archetype_names = get_archetype_names

    player_id = 0
    contract_id = 0
    archetype_id = 0
    role_id = 0

    CSV.foreach(Rails.root.join("players.csv"), {headers: true, header_converters: :symbol}) do |row|
      next unless row[:contractstatus] == "FreeAgent" || (row[:contractstatus] == "Signed" && row[:teamindex].to_i < 32)

      player_id += 1
      cap_hit = 0
      cap_savings = 0
      cap_penalty = 0
      player_archetypes = []

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

        player_archetypes << {
          name: archetype_names[row[:position]][index],
          rating: row["overallgrade#{index}".to_sym].to_i,
        }

        archetypes << {
          id: archetype_id,
          player_id: player_id,
          name: archetype_names[row[:position]][index],
          overall_rating: row["overallgrade#{index}".to_sym].to_i,
        }
      end

      player_role, role_id = get_role(role_id, player_id, row[:position], row[:weight].to_i, player_archetypes)
      roles << player_role


      players << {
        id: player_id,
        team_id: row[:teamindex].to_i < 32 ? (row[:teamindex].to_i + 1) : nil,
        name: [row[:firstname], row[:lastname]].compact.join(" "),
        position: row[:position],
        status: row[:contractstatus],
        development_trait: row[:traitdevelopment],
        age: row[:age].to_i,
        overall_rating: row[:overallrating].to_i,
        draft_round: row[:plyr_draftround].to_i,
        draft_pick: row[:plyr_draftpick].to_i,
        year_drafted: (2019 + row[:yeardrafted].to_i),
        years_pro: row[:yearspro].to_i,
        contract_length: row[:contractlength].to_i,
        contract_year: (row[:contractyear].to_i + 1),
        contract_years_left: (row[:contractlength].to_i - row[:contractyear].to_i),
        cap_hit: cap_hit,
        cap_savings: cap_savings,
        cap_penalty: cap_penalty,
      }
    end

    [players, contracts, archetypes, roles]
  end

  def get_archetype_names
    {
      "QB"=>["Field General", "Strong Arm", "Improviser", "Scrambler"],
      "HB"=>["Power Back", "Elusive Back", "Receiving Back"],
      "FB"=>["Utility", "Blocking"],
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

  def get_role_names
    {
      "LT"=>["OT"],
      "LG"=>["IOL"],
      "C"=>["IOL"],
      "RG"=>["IOL"],
      "RT"=>["OT"],
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

  def get_role(role_id, player_id, position, weight, archetypes)
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
      if role[:rating].zero?
        nil
      else
        role_id += 1
        role.merge({id: role_id, player_id: player_id})
      end
    end.compact.first

    [player_role, role_id]
  end

  def get_quarterback_role(archetypes)
    role_value = 0.18.to_d

    field_general = archetypes.detect{|a| a[:name] == "Field General"}.to_h[:rating].to_d
    improviser = archetypes.detect{|a| a[:name] == "Improviser"}.to_h[:rating].to_d
    strong_arm = archetypes.detect{|a| a[:name] == "Strong Arm"}.to_h[:rating].to_d
    scrambler = archetypes.detect{|a| a[:name] == "Scrambler"}.to_h[:rating].to_d
    max_rating = [field_general, improviser, strong_arm].max

    is_balanced = (field_general.between?(max_rating - 3, max_rating) && improviser.between?(max_rating - 3, max_rating) && strong_arm.between?(max_rating - 3, max_rating))
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
    role_value = 0.0315.to_d

    power = archetypes.detect{|a| a[:name] == "Elusive Back"}.to_h[:rating].to_d
    elusive = archetypes.detect{|a| a[:name] == "Power Back"}.to_h[:rating].to_d
    receiving = archetypes.detect{|a| a[:name] == "Receiving Back"}.to_h[:rating].to_d
    power_or_elusive = [power, elusive].max

    is_balanced = receiving.between?(power_or_elusive - 3, power_or_elusive + 3)
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
    role_value = 0.0195.to_d

    utility = archetypes.detect{|a| a[:name] == "Utility"}.to_h[:rating].to_d
    blocking = archetypes.detect{|a| a[:name] == "Blocking"}.to_h[:rating].to_d

    is_balanced = utility.between?(blocking - 3, blocking + 3)
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
    role_value = 0.04.to_d

    route_runner = archetypes.detect{|a| a[:name] == "Route Runner"}.to_h[:rating].to_d
    slot = archetypes.detect{|a| a[:name] == "Slot"}.to_h[:rating].to_d
    deep_threat = archetypes.detect{|a| a[:name] == "Deep Threat"}.to_h[:rating].to_d
    physical = archetypes.detect{|a| a[:name] == "Physical"}.to_h[:rating].to_d
    max_rating = [route_runner, slot, deep_threat].max

    is_balanced = (route_runner.between?(max_rating - 3, max_rating) && slot.between?(max_rating - 3, max_rating) && deep_threat.between?(max_rating - 3, max_rating))
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
    role_value = 0.0345.to_d

    possession = archetypes.detect{|a| a[:name] == "Possession"}.to_h[:rating].to_d
    vertical = archetypes.detect{|a| a[:name] == "Vertical Threat"}.to_h[:rating].to_d
    blocking = archetypes.detect{|a| a[:name] == "Blocking"}.to_h[:rating].to_d
    max_rating = [possession, vertical, blocking].max

    is_balanced = (possession.between?(max_rating - 3, max_rating) && vertical.between?(max_rating - 3, max_rating) && blocking.between?(max_rating - 3, max_rating))
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
    role_value = 0.039.to_d

    pass_protect = archetypes.detect{|a| a[:name] == "Pass Protector"}.to_h[:rating].to_d
    power = archetypes.detect{|a| a[:name] == "Power"}.to_h[:rating].to_d
    agile = archetypes.detect{|a| a[:name] == "Agile"}.to_h[:rating].to_d
    power_or_agile = [power, agile].max

    is_balanced = pass_protect.between?(power_or_agile - 3, power_or_agile + 3)
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
    role_value = 0.022.to_d

    pass_protect = archetypes.detect{|a| a[:name] == "Pass Protector"}.to_h[:rating].to_d
    power = archetypes.detect{|a| a[:name] == "Power"}.to_h[:rating].to_d
    agile = archetypes.detect{|a| a[:name] == "Agile"}.to_h[:rating].to_d
    power_or_agile = [power, agile].max

    is_balanced = pass_protect.between?(power_or_agile - 3, power_or_agile + 3)
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
    return nil if weight >= 120
    role_value = 0.0395.to_d

    power = archetypes.detect{|a| a[:name] == "Power Rusher"}.to_h[:rating].to_d
    speed = archetypes.detect{|a| a[:name] == "Speed Rusher"}.to_h[:rating].to_d

    if position.in?(["LOLB","ROLB"])
      run_stopper = archetypes.detect{|a| a[:name] == "Run Stopper"}.to_h[:rating].to_d
      pass_coverage = archetypes.detect{|a| a[:name] == "Pass Coverage"}.to_h[:rating].to_d
      return nil if [run_stopper, pass_coverage].sum > [power, speed].sum
    end

    is_balanced = power.between?(speed - 3, speed + 3)
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
    return nil if weight < 120
    role_value = 0.021.to_d

    power = archetypes.detect{|a| a[:name] == "Power Rusher"}.to_h[:rating].to_d
    speed = archetypes.detect{|a| a[:name] == "Speed Rusher"}.to_h[:rating].to_d
    run_stopper = archetypes.detect{|a| a[:name] == "Run Stopper"}.to_h[:rating].to_d
    power_or_speed = [power, speed].max

    is_balanced = run_stopper.between?(power_or_speed - 3, power_or_speed + 3)
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
    role_value = 0.0205.to_d

    run_stopper = archetypes.detect{|a| a[:name] == "Run Stopper"}.to_h[:rating].to_d
    pass_coverage = archetypes.detect{|a| a[:name] == "Pass Coverage"}.to_h[:rating].to_d

    if position.in?(["LOLB","ROLB"])
      power = archetypes.detect{|a| a[:name] == "Power Rusher"}.to_h[:rating].to_d
      speed = archetypes.detect{|a| a[:name] == "Speed Rusher"}.to_h[:rating].to_d
      return nil if [power, speed].sum >= [run_stopper, pass_coverage].sum && weight < 120
    end

    is_balanced = run_stopper.between?(pass_coverage - 3, pass_coverage + 3)
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
    role_value = 0.039.to_d

    man = archetypes.detect{|a| a[:name] == "Man to Man"}.to_h[:rating].to_d
    zone = archetypes.detect{|a| a[:name] == "Zone"}.to_h[:rating].to_d
    slot = archetypes.detect{|a| a[:name] == "Slot"}.to_h[:rating].to_d
    max_rating = [man, zone, slot].max

    is_balanced = (man.between?(max_rating - 3, max_rating) && zone.between?(max_rating - 3, max_rating) && slot.between?(max_rating - 3, max_rating))
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
    role_value = 0.0332.to_d

    coverage = archetypes.detect{|a| a[:name] == "Zone"}.to_h[:rating].to_d
    run_support = archetypes.detect{|a| a[:name] == "Run Support"}.to_h[:rating].to_d

    is_balanced = run_support.between?(coverage - 3, coverage + 3)
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
    role_value = 0.004.to_d

    accurate = archetypes.detect{|a| a[:name] == "Accurate"}.to_h[:rating].to_d
    power = archetypes.detect{|a| a[:name] == "Power"}.to_h[:rating].to_d

    is_balanced = accurate.between?(power - 3, power + 3)
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
    role_value = 0.002.to_d

    accurate = archetypes.detect{|a| a[:name] == "Accurate"}.to_h[:rating].to_d
    power = archetypes.detect{|a| a[:name] == "Power"}.to_h[:rating].to_d

    is_balanced = accurate.between?(power - 3, power + 3)
    rating = [accurate * 0.5.to_d, power * 0.5.to_d].sum

    if is_balanced
      {name: "P", style: "Balanced", rating: rating.round, value: ((rating * 1.01.to_d) * role_value).round(2)}
    elsif power > accurate
      {name: "P", style: "Power", rating: rating.round, value: (rating * role_value).round(2)}
    else
      {name: "P", style: "Accurate", rating: rating.round, value: (rating * role_value).round(2)}
    end
  end
end
