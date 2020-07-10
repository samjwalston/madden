class Import::Players < ApplicationService
  require 'csv'

  def call
    ::Player.delete_all
    ::Contract.delete_all
    ::Archetype.delete_all
    ::Category.delete_all
    ::Role.delete_all

    players, contracts, archetypes, categories, roles = get_values

    players.each_slice(100){|values| ::Player.create(values)}
    contracts.each_slice(100){|values| ::Contract.create(values)}
    archetypes.each_slice(100){|values| ::Archetype.create(values)}
    categories.each_slice(100){|values| ::Category.create(values)}
    roles.each_slice(100){|values| ::Role.create(values)}

    nil
  end


  private

  def get_values
    players = []
    contracts = []
    archetypes = []
    categories = []
    roles = []
    archetype_names = get_archetype_names

    player_id = 0
    contract_id = 0
    archetype_id = 0
    category_id = 0
    role_id = 0

    CSV.foreach(Rails.root.join("players.csv"), {headers: true, header_converters: :symbol}) do |row|
      next unless row[:contractstatus] == "FreeAgent" || (row[:contractstatus] == "Signed" && row[:teamindex].to_i < 32)

      # if row[:skillpoints].to_i > 0 && row[:teamindex].to_i >= 32
      #   puts [row[:skillpoints], row[:overallrating], row[:position], row[:firstname], row[:lastname]].compact.join(" ")
      # end

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

      player_categories, category_id = get_categories(category_id, player_id, row[:position], row[:weight].to_i, player_archetypes)
      categories.concat(player_categories)

      player_roles, role_id = get_roles(role_id, player_id, row[:position], player_categories, player_archetypes)
      roles.concat(player_roles)


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

    [players, contracts, archetypes, categories, roles]
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

  def get_categories(category_id, player_id, position, weight, archetypes)
    position_categories = get_category_names
    category_names = position_categories[position]
    categories = []

    category_names.each do |category_name|
      category_id += 1

      rating = if position == "QB"
        [
          archetypes.detect{|a| a[:name] == "Field General"}.to_h[:rating].to_d * 0.3.to_d,
          archetypes.detect{|a| a[:name] == "Strong Arm"}.to_h[:rating].to_d * 0.25.to_d,
          archetypes.detect{|a| a[:name] == "Improviser"}.to_h[:rating].to_d * 0.25.to_d,
          archetypes.detect{|a| a[:name] == "Scrambler"}.to_h[:rating].to_d * 0.2.to_d
        ].sum.floor
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
        ].sum.floor
      elsif position == "WR"
        if category_name == "Outside Receiver"
          [
            archetypes.detect{|a| a[:name] == "Route Runner"}.to_h[:rating].to_d * 0.75.to_d,
            archetypes.detect{|a| a[:name] == "Deep Threat"}.to_h[:rating].to_d * 0.25.to_d
          ].sum.floor
        else
          [
            archetypes.detect{|a| a[:name] == "Slot"}.to_h[:rating].to_d * 0.75.to_d,
            archetypes.detect{|a| a[:name] == "Physical"}.to_h[:rating].to_d * 0.25.to_d
          ].sum.floor
        end
      elsif position == "TE"
        if category_name == "Receiver"
          [
            archetypes.detect{|a| a[:name] == "Possession"}.to_h[:rating].to_d * 0.5.to_d,
            archetypes.detect{|a| a[:name] == "Vertical Threat"}.to_h[:rating].to_d * 0.5.to_d
          ].sum.floor
        else
          archetypes.detect{|a| a[:name] == "Blocking"}.to_h[:rating].to_d
        end
      elsif position.in?(["LT", 'LG', "C", "RG", "RT"])
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
          if weight < 120 # Weight starts at 160 lbs
            [
              archetypes.detect{|a| a[:name] == "Power Rusher"}.to_h[:rating].to_d * 0.5.to_d,
              archetypes.detect{|a| a[:name] == "Speed Rusher"}.to_h[:rating].to_d * 0.5.to_d
            ].sum.floor
          else
            0
          end
        elsif category_name == "Interior Rusher"
          if weight >= 120 # Weight starts at 160 lbs
            [
              archetypes.detect{|a| a[:name] == "Power Rusher"}.to_h[:rating].to_d * 0.75.to_d,
              archetypes.detect{|a| a[:name] == "Speed Rusher"}.to_h[:rating].to_d * 0.25.to_d
            ].sum.floor
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
          ].sum.floor
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
          ].sum.floor
        else
          [
            archetypes.detect{|a| a[:name] == "Run Stopper"}.to_h[:rating].to_d * 0.75.to_d,
            archetypes.detect{|a| a[:name] == "Field General"}.to_h[:rating].to_d * 0.25.to_d
          ].sum.floor
        end
      elsif position == "CB"
        if category_name == "Outside Coverage"
          [
            archetypes.detect{|a| a[:name] == "Man to Man"}.to_h[:rating].to_d * 0.5.to_d,
            archetypes.detect{|a| a[:name] == "Zone"}.to_h[:rating].to_d * 0.5.to_d
          ].sum.floor
        else
          [
            archetypes.detect{|a| a[:name] == "Slot"}.to_h[:rating].to_d * 0.6.to_d,
            archetypes.detect{|a| a[:name] == "Man to Man"}.to_h[:rating].to_d * 0.2.to_d,
            archetypes.detect{|a| a[:name] == "Zone"}.to_h[:rating].to_d * 0.2.to_d
          ].sum.floor
        end
      elsif position.in?(["FS", "SS"])
        if category_name == "Pass Coverage"
          [
            archetypes.detect{|a| a[:name] == "Zone"}.to_h[:rating].to_d * 0.5.to_d,
            archetypes.detect{|a| a[:name] == "Hybrid"}.to_h[:rating].to_d * 0.5.to_d
          ].sum.floor
        else
          [
            archetypes.detect{|a| a[:name] == "Run Support"}.to_h[:rating].to_d * 0.5.to_d,
            archetypes.detect{|a| a[:name] == "Hybrid"}.to_h[:rating].to_d * 0.5.to_d
          ].sum.floor
        end
      elsif position == "K"
        [
          archetypes.detect{|a| a[:name] == "Accurate"}.to_h[:rating].to_d * 0.75.to_d,
          archetypes.detect{|a| a[:name] == "Power"}.to_h[:rating].to_d * 0.25.to_d
        ].sum.floor
      elsif position == "P"
        [
          archetypes.detect{|a| a[:name] == "Accurate"}.to_h[:rating].to_d * 0.5.to_d,
          archetypes.detect{|a| a[:name] == "Power"}.to_h[:rating].to_d * 0.5.to_d
        ].sum.floor
      else
        0
      end

      categories << {id: category_id, player_id: player_id, name: category_name, rating: rating.to_i}
    end

    [categories, category_id]
  end

  def get_roles(role_id, player_id, position, categories, archetypes)
    position_roles = get_role_names
    role_names = (position_roles[position] || [position])
    roles = []

    role_names.each do |role_name|
      role_id += 1
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
        value = (category[:rating].to_d * 0.2016.to_d).round(2)
        style_name = (pocket_rating >= mobile_rating ? "Pocket" : "Mobile")
      elsif role_name == "HB"
        archetype = archetypes.sort{|a,b| b[:rating] <=> a[:rating]}.first

        rating = archetype[:rating]
        value = (archetype[:rating].to_d * 0.0364.to_d).round(2)
        style_name = (archetype[:name].split(" ").first)
      elsif role_name == "FB"
        category = categories.first
        archetype = archetypes.sort{|a,b| b[:rating] <=> a[:rating]}.first

        rating = category[:rating]
        value = (category[:rating].to_d * 0.0084.to_d).round(2)
        style_name = archetype[:name]
      elsif role_name == "WR"
        outside = categories.detect{|a| a[:name] == "Outside Receiver"}.to_h[:rating].to_d
        slot = categories.detect{|a| a[:name] == "Slot Receiver"}.to_h[:rating].to_d

        if outside >= slot
          rating = outside
          value = (outside.to_d * 0.0571.to_d).round(2)
          style_name = "Outside"
        else
          rating = slot
          value = (slot.to_d * 0.0381.to_d).round(2)
          style_name = "Slot"
        end
      elsif role_name == "TE"
        receiver = categories.detect{|a| a[:name] == "Receiver"}.to_h[:rating].to_d
        blocker = categories.detect{|a| a[:name] == "Blocker"}.to_h[:rating].to_d

        if receiver >= blocker
          rating = receiver
          value = (receiver.to_d * 0.037.to_d).round(2)
          style_name = "Receiver"
        else
          rating = blocker
          value = (blocker.to_d * 0.0185.to_d).round(2)
          style_name = "Blocking"
        end
      elsif role_name == "OT"
        pass = categories.detect{|a| a[:name] == "Pass Blocker"}.to_h[:rating].to_d
        run = categories.detect{|a| a[:name] == "Run Blocker"}.to_h[:rating].to_d

        if pass >= run
          rating = pass
          value = (pass.to_d * 0.0367.to_d).round(2)
          style_name = "Pass Protector"
        else
          power = archetypes.detect{|a| a[:name] == "Power"}.to_h[:rating].to_d
          agile = archetypes.detect{|a| a[:name] == "Agile"}.to_h[:rating].to_d

          rating = run
          value = (run.to_d * 0.0367.to_d).round(2)
          style_name = (power >= agile ? "Power" : "Agile")
        end
      elsif role_name == "IOL"
        pass = categories.detect{|a| a[:name] == "Pass Blocker"}.to_h[:rating].to_d
        run = categories.detect{|a| a[:name] == "Run Blocker"}.to_h[:rating].to_d

        if pass > run
          rating = pass
          value = (pass.to_d * 0.0196.to_d).round(2)
          style_name = "Pass Protector"
        else
          power = archetypes.detect{|a| a[:name] == "Power"}.to_h[:rating].to_d
          agile = archetypes.detect{|a| a[:name] == "Agile"}.to_h[:rating].to_d

          rating = run
          value = (run.to_d * 0.0196.to_d).round(2)
          style_name = (power >= agile ? "Power" : "Agile")
        end
      elsif role_name == "EDGE"
        category = categories.detect{|a| a[:name] == "Edge Rusher"}

        unless category[:rating].zero?
          power = archetypes.detect{|a| a[:name] == "Power Rusher"}.to_h[:rating].to_d
          speed = archetypes.detect{|a| a[:name] == "Speed Rusher"}.to_h[:rating].to_d

          rating = category[:rating]
          value = (category[:rating].to_d * 0.0474.to_d).round(2)
          style_name = (power >= speed ? "Power" : "Speed")
        end
      elsif role_name == "IDL"
        rusher = categories.detect{|a| a[:name] == "Interior Rusher"}.to_h[:rating].to_d

        unless rusher.zero?
          run = categories.detect{|a| a[:name] == "Run Stopper"}.to_h[:rating].to_d

          if rusher > run
            rating = rusher
            value = (rusher.to_d * 0.0302.to_d).round(2)
            style_name = "Pass Rusher"
          else
            rating = run
            value = (run.to_d * 0.02265.to_d).round(2)
            style_name = "Run Stopper"
          end
        end
      elsif role_name == "LB"
        run = categories.detect{|a| a[:name] == "Run Stopper"}.to_h[:rating].to_d
        pass = categories.detect{|a| a[:name] == "Pass Coverage"}.to_h[:rating].to_d
        score = ([run, pass].sum / 2.to_d).floor.to_i

        rating = score
        value = (score.to_d * 0.0259.to_d).round(2)
        style_name = (pass > run ? "Outside" : "Inside")
      elsif role_name == "CB"
        outside = categories.detect{|a| a[:name] == "Outside Coverage"}.to_h[:rating].to_d
        slot = categories.detect{|a| a[:name] == "Slot Coverage"}.to_h[:rating].to_d

        if outside >= slot
          rating = outside
          value = (outside.to_d * 0.0516.to_d).round(2)
          style_name = "Outside"
        else
          rating = slot
          value = (slot.to_d * 0.0516.to_d).round(2)
          style_name = "Slot"
        end
      elsif role_name == "S"
        pass = categories.detect{|a| a[:name] == "Pass Coverage"}.to_h[:rating].to_d
        run = categories.detect{|a| a[:name] == "Run Stopper"}.to_h[:rating].to_d

        if pass >= run
          rating = pass
          value = (pass.to_d * 0.0387.to_d).round(2)
          style_name = "Free"
        else
          rating = run
          value = (run.to_d * 0.0301.to_d).round(2)
          style_name = "Strong"
        end
      elsif role_name == "K"
        category = categories.first
        accurate = archetypes.detect{|a| a[:name] == "Accurate"}.to_h[:rating].to_d
        power = archetypes.detect{|a| a[:name] == "Power"}.to_h[:rating].to_d

        rating = category[:rating]
        value = (category[:rating].to_d * 0.007.to_d).round(2)
        style_name = (accurate >= power ? "Accurate" : "Power")
      elsif role_name == "P"
        category = categories.first
        accurate = archetypes.detect{|a| a[:name] == "Accurate"}.to_h[:rating].to_d
        power = archetypes.detect{|a| a[:name] == "Power"}.to_h[:rating].to_d

        rating = category[:rating]
        value = (category[:rating].to_d * 0.003.to_d).round(2)
        style_name = (accurate >= power ? "Accurate" : "Power")
      end

      unless rating.zero?
        roles << {
          id: role_id,
          player_id: player_id,
          name: role_name,
          style: style_name,
          rating: rating,
          value: value
        }
      end
    end

    [roles, role_id]
  end
end
