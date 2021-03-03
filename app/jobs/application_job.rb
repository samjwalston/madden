class ApplicationJob < ActiveJob::Base
  private

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
end
