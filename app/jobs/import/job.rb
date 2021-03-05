class Import::Job < ApplicationJob
  require 'csv'


  private

  def get_role(position, weight, archetypes)
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

    role
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
      "LE"=>["ED", "IDL"],
      "RE"=>["ED", "IDL"],
      "DT"=>["IDL"],
      "LOLB"=>["ED", "LB"],
      "MLB"=>["LB"],
      "ROLB"=>["ED", "LB"],
      "FS"=>["S"],
      "SS"=>["S"],
    }
  end

  def get_letter_grade(rating)
    if rating >= 80
      "A+"
    elsif rating >= 78 && rating <= 79
      "A"
    elsif rating >= 76 && rating <= 77
      "A-"
    elsif rating >= 74 && rating <= 75
      "B+"
    elsif rating >= 72 && rating <= 73
      "B"
    elsif rating >= 70 && rating <= 71
      "B-"
    elsif rating >= 68 && rating <= 69
      "C+"
    elsif rating >= 66 && rating <= 67
      "C"
    elsif rating >= 64 && rating <= 65
      "C-"
    elsif rating >= 62 && rating <= 63
      "D+"
    elsif rating >= 60 && rating <= 61
      "D"
    else
      "F"
    end
  end
end
