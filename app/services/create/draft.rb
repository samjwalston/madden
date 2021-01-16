class Create::Draft < ApplicationService
  require 'csv'


  def call(year, is_test = false)
    picks = []

    ROUNDS.each_with_index do |values, index|
      count = if index == 5
        (450 - picks.flatten.size)
      else
        min, max = values
        [max, [min, gaussian(((min + max) / 2.0), ((max - min) / 5.0)).round.to_i].max].min
      end

      picks << get_positions(index, count)
    end

    if is_test == true
      picks.flatten.compact
    else
      update_csv(year, picks.flatten.compact)
      nil
    end
  end


  protected

  def get_positions(index, count, picks = [])
    while picks.size < count
      picks = select_positions(index, count, picks)
    end

    picks
  end

  def select_positions(index, count, picks)
    add_bases = picks.empty?

    RANGES.keys.shuffle.each do |position|
      next if picks.size >= count
      min, max = RANGES[position][index]

      min.times{picks << get_details(index, position)} if add_bases

      if RATES[position][index] >= Kernel.rand
        if picks.dup.keep_if{|p| p == position}.size < max
          picks << get_details(index, position)
        end
      end
    end

    if picks.size > count
      picks[0...(count - picks.size)]
    else
      picks
    end
  end

  def get_details(index, position)
    klass = "Create::Player::#{NAMES[position]}".safe_constantize
    klass.call(index)
  end

  def update_csv(year, picks, index = nil, data = [])
    CSV.foreach(Rails.root.join("draft.csv"), {headers: true, header_converters: :symbol}) do |row|
      next if row[:ppos].blank?

      pick = picks.detect.with_index do |p,i|
        if p[:POS].split("-").last.in?(get_similar_positions(POSITIONS[row[:ppos].to_i]))
          index = i; true
        end
      end

      if pick.nil?
        pick = picks.detect.with_index do |p,i|
          if row[:pdro].to_i == 63
            index = i; true
          end
        end
      end

      if !pick.nil?
        picks.delete_at(index) unless index.nil?
        pick = pick.symbolize_keys

        info = row.map do |key, value|
          key = KEYS[key.to_s.upcase.to_sym]
          key.blank? ? value : pick[key.to_sym].to_s.split("-").last.to_s
        end

        info[5] = get_birthdate(year, pick[:AGE])
        info[9] = POSITIONS.index(pick[:POS].to_s.split("-").last)

        data << [(pick[:OVR] * VALUES[pick[:POS].to_s.split("-").first.to_sym].to_d) + ((pick[:AGE] - 22) * -1), info]
      else
        data << [(row[:povr].to_i * VALUES[POSITIONS[row[:ppos].to_i].to_sym].to_d) + ((row[:page].to_i - 22) * -1), row.to_h.values]
      end
    end

    data = data.sort{|a,b| b.first<=>a.first}.map.with_index do |info, index|
      num = (index + 1)
      info = info.last

      if index < 224
        info[12] = (num - (((num / 32.to_d).ceil - 1) * 32.to_d)).round
        info[13] = 0
        info[14] = (num / 32.to_d).ceil
      else
        info[12] = (num - 224)
        info[13] = 1
        info[14] = 63
      end

      info
    end

    CSV.open(Rails.root.join("draft_new.csv"), "wb") do |row|
      data.each do |info|
        row << info
      end
    end
  end

  def get_similar_positions(position)
    case position
    when "LT", "RT"
      ["LT", "RT"]
    when "LG", "C", "RG"
      ["LG", "C", "RG"]
    when "LE", "RE"
      ["LE", "RE"]
    when "LOLB", "ROLB"
      ["LOLB", "ROLB"]
    when "FS", "SS"
      ["FS", "SS"]
    when "K", "P"
      ["K", "P"]
    else
      [position]
    end
  end


  private

  ROUNDS = [[5,11],[16,28],[24,48],[48,96],[96,144],[123,261]].freeze

  RANGES = {
    "QB":   [[0,1],[1,2],[1,3],[1,6],[1,10],[2,7]],
    "RB":   [[0,1],[0,2],[3,8],[3,12],[2,15],[9,22]],
    "WR":   [[0,2],[1,6],[3,8],[5,16],[4,20],[13,29]],
    "TE":   [[0,1],[0,2],[1,5],[1,11],[0,14],[7,17]],
    "OT":   [[0,2],[1,5],[1,5],[3,13],[2,17],[8,20]],
    "IOL":  [[0,1],[0,2],[3,9],[3,16],[3,19],[12,29]],
    "EDGE": [[0,2],[1,5],[2,7],[5,16],[5,18],[7,16]],
    "IDL":  [[0,2],[1,5],[2,8],[5,16],[5,19],[12,29]],
    "LB":   [[0,1],[0,3],[2,6],[3,11],[3,14],[9,22]],
    "CB":   [[0,2],[1,6],[1,8],[2,16],[3,20],[12,27]],
    "S":    [[0,2],[1,4],[1,5],[1,11],[2,14],[11,29]],
    "K":    [[0,0],[0,0],[0,1],[0,1],[0,2],[9,14]],
  }.freeze

  RATES = {
    "QB":   [0.05, 0.05, 0.1, 0.25, 0.45, 1],
    "RB":   [0.1, 0.1, 0.25, 0.45, 0.65, 1],
    "WR":   [0.1, 0.25, 0.25, 0.55, 0.8, 1],
    "TE":   [0.01, 0.1, 0.2, 0.5, 0.7, 1],
    "OT":   [0.1, 0.2, 0.2, 0.5, 0.75, 1],
    "IOL":  [0.01, 0.1, 0.3, 0.65, 0.8, 1],
    "EDGE": [0.15, 0.2, 0.2, 0.55, 0.65, 1],
    "IDL":  [0.15, 0.2, 0.25, 0.55, 0.7, 1],
    "LB":   [0.05, 0.15, 0.2, 0.4, 0.55, 1],
    "CB":   [0.1, 0.25, 0.35, 0.7, 0.85, 1],
    "S":    [0.1, 0.15, 0.2, 0.5, 0.6, 1],
    "K":    [0, 0, 0.01, 0.1, 0.25, 1],
  }.freeze

  NAMES = {
    "QB": "Quarterback",
    "RB": "Runningback",
    "WR": "WideReceiver",
    "TE": "TightEnd",
    "OT": "OffensiveTackle",
    "IOL": "InteriorOffensiveLine",
    "EDGE": "Edge",
    "IDL": "InteriorDefensiveLine",
    "LB": "Linebacker",
    "CB": "Cornerback",
    "S": "Safety",
    "K": "Kicker",
  }.freeze

  POSITIONS = ["QB","HB","FB","WR","TE","LT","LG","C","RG","RT","LE","RE","DT","LOLB","MLB","ROLB","CB","FS","SS","K","P"].freeze

  VALUES = {
    "QB":   1,
    "HB":   0.91,
    "FB":   0.5,
    "WR":   0.99,
    "TE":   0.95,
    "OT":   0.97,
    "IOL":  0.9,
    "EDGE": 0.98,
    "IDL":  0.94,
    "LB":   0.93,
    "CB":   0.96,
    "S":    0.92,
    "K":    0.5,
    "P":    0.5,
  }.freeze

  KEYS = {
    "PAGE": "AGE", # Age
    "PJEN": "JEN", # Jersey Number
    "PHGT": "HGT", # Height
    "PWGT": "WGT", # Weight
    "POVR": "OVR", # Overall
    "PSPD": "SPD", # Speed
    "PACC": "ACC", # Acceleration
    "PAGI": "AGI", # Agility
    "PSTR": "STR", # Strength
    "PAWR": "AWR", # Awareness
    "PCAR": "CAR", # Carrying
    "PBCV": "BCV", # Ball Carrier Vision
    "PBKT": "BKT", # Break Tackle
    "PLTR": "TRK", # Trucking
    "PLSA": "SFA", # Stiff Arm
    "PELU": "ELU", # Elusiveness
    "PLSM": "SPM", # Spin Move
    "PLJM": "JKM", # Juke Move
    "PCTH": "CAT", # Catching
    "PLCI": "CIT", # Catch in Traffic
    "PLSC": "SPC", # Spectacular Catch
    "SRRN": "SRR", # Short Route Running
    "PMRR": "MRR", # Medium Route Running
    "PDRR": "DRR", # Deep Route Running
    "PLRL": "REL", # Release
    "PJMP": "JUM", # Jumping
    "PTHP": "THP", # Throwing Power
    "PTAS": "SAC", # Short Throw Accuracy
    "PTAM": "MAC", # Medium Throw Accuracy
    "PTAD": "DAC", # Deep Throw Accuracy
    "PTOR": "TOR", # Throw on the Run
    "PTUP": "TUP", # Throw Under Pressure
    "PBSK": "BSK", # Break Sack
    "PPLA": "PLA", # Play Action
    "PPBK": "PBL", # Pass Blocking
    "PPBS": "PBP", # Pass Block Power
    "PPBF": "PBF", # Pass Block Finesse
    "PRBK": "RBL", # Run Blocking
    "PRBS": "RBP", # Run Block Power
    "PRBF": "RBF", # Run Block Finesse
    "PLBK": "LBK", # Lead Block
    "PLIB": "IMP", # Impact Blocking
    "PLPR": "PLR", # Play Recognition
    "PTAK": "TAK", # Tackling
    "PLHT": "HIT", # Hit Power
    "PBSG": "BSG", # Block Shedding
    "PFMS": "FMV", # Finesse Moves
    "PLPm": "PMV", # Power Moves
    "PLPU": "PUR", # Pursuit
    "PLMC": "MCV", # Man Coverage
    "PLZC": "ZCV", # Zone Coverage
    "PLPE": "PRE", # Press
    "PKRT": "KRT", # Kick/Punt Return
    "PKPR": "KPW", # Kick Power
    "PKAC": "KAC", # Kick Accuracy
    "PSTA": "STA", # Stamina
    "PTGH": "TGH", # Toughness
    "PINJ": "INJ", # Injury
  }.freeze
end
