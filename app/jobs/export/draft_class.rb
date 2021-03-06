class Export::DraftClass < ApplicationJob
  def perform(year)
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

    update_csv(year, picks.flatten.compact)
    nil
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
    klass = "Create::#{NAMES[position]}".safe_constantize
    klass.call(index).merge({"IDX": index})
  end

  def update_csv(year, picks, index = nil, data = [])
    dev_traits = [0,0,0,0]

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

        info[2] = "PLACEHOLDER_#{year}"
        info[5] = get_birthdate(year, pick[:AGE])
        info[9] = POSITIONS.index(pick[:POS].to_s.split("-").last)

        dev_trait = get_dev_trait(pick[:AGE], pick[:IDX])

        while dev_traits[dev_trait] >= TRAIT_MAXS[dev_trait]
          dev_trait -= 1
        end

        dev_traits[dev_trait] += 1
        info[96] = [dev_trait, 0].max

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

  def get_birthdate(year, age)
    day = (age == 20 ? Kernel.rand(100..365) : Kernel.rand(1..365))
    year = (year - (day <= 100 ? age : (age + 1)))
    Date.ordinal(year, day).strftime("%-m/%-d/%Y")
  end

  def get_dev_trait(age, round, rand = Kernel.rand)
    cutoffs = DEV_TRAITS[age.to_s.to_sym][round]

    if rand >= cutoffs[0]
      3
    elsif rand >= cutoffs[1]
      2
    elsif rand >= cutoffs[2]
      1
    else
      0
    end
  end


  private

  ROUNDS = [[0,3],[4,12],[8,24],[24,72],[72,216],[123,342]].freeze

  TRAIT_MAXS = [450, 40, 8, 2]

  DEV_TRAITS = {
    "20": [[0.5,0,0],[1,1,1],[1,1,1],[1,1,1],[1,1,1],[1,1,1]],
    "21": [[0.75,0,0],[0.9,0.4,0],[1,0.75,0.25],[1,1,0.5],[1,1,0.75],[1,1,1]],
    "22": [[0.9,0,0],[1,0.6,0.3],[1,0.8,0.4],[1,1,0.6],[1,1,0.7],[1,1,0.85]],
    "23": [[1,1,1],[1,1,1],[1,0.95,0.5],[1,1,0.7],[1,1,0.8],[1,1,0.9]],
    "24": [[1,1,1],[1,1,1],[1,1,1],[1,1,1],[1,1,0.9],[1,1,0.95]]
  }.freeze

  RANGES = {
    "QB":   [[0,1],[0,3],[1,3],[2,5],[3,10],[6,12]],
    "RB":   [[0,1],[0,3],[1,4],[3,8],[8,21],[9,27]],
    "WR":   [[0,1],[1,4],[0,5],[2,12],[8,30],[14,37]],
    "TE":   [[0,1],[0,2],[1,3],[2,8],[4,20],[8,25]],
    "OT":   [[0,1],[0,4],[1,4],[2,10],[8,26],[10,33]],
    "IOL":  [[0,1],[0,3],[1,5],[2,12],[8,30],[13,37]],
    "EDGE": [[0,1],[0,3],[1,5],[2,10],[6,26],[10,33]],
    "IDL":  [[0,2],[1,4],[0,5],[2,12],[8,30],[13,35]],
    "LB":   [[0,1],[0,3],[1,4],[2,10],[6,25],[10,28]],
    "CB":   [[0,1],[1,4],[0,5],[2,12],[8,30],[14,37]],
    "S":    [[0,1],[0,3],[0,4],[2,8],[4,21],[10,28]],
    "K":    [[0,0],[0,0],[0,1],[0,1],[0,1],[6,10]],
  }.freeze

  RATES = {
    "QB":   [0.06, 0.18, 0.11, 0.22, 0.4, 0.33],
    "RB":   [0.11, 0.2, 0.14, 0.22, 0.42, 0.74],
    "WR":   [0.06, 0.05, 0.42, 0.62, 0.78, 0.86],
    "TE":   [0.01, 0.2, 0.04, 0.3, 0.63, 0.64],
    "OT":   [0.11, 0.2, 0.22, 0.5, 0.6, 0.9],
    "IOL":  [0.01, 0.25, 0.23, 0.58, 0.75, 0.89],
    "EDGE": [0.11, 0.2, 0.22, 0.5, 0.75, 0.86],
    "IDL":  [0.11, 0.05, 0.5, 0.66, 0.8, 0.89],
    "LB":   [0.09, 0.2, 0.16, 0.46, 0.7, 0.75],
    "CB":   [0.06, 0.05, 0.42, 0.62, 0.78, 0.86],
    "S":    [0.09, 0.2, 0.38, 0.34, 0.67, 0.6],
    "K":    [0, 0, 0.01, 0.05, 0.1, 0.33],
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
    "HB":   0.9727,
    "FB":   0.72,
    "WR":   0.9847,
    "TE":   0.9798,
    "OT":   0.9811,
    "IOL":  0.9718,
    "EDGE": 0.9837,
    "IDL":  0.9746,
    "LB":   0.974,
    "CB":   0.9807,
    "S":    0.9737,
    "K":    0.73,
    "P":    0.71,
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
