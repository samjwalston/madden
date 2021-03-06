class Create::Quarterback < Create::Player
  def call(level, test_archetype = nil)
    archetype = test_archetype.nil? ? get_archetype(level) : test_archetype
    height = SIZES[archetype.to_sym].keys.sample
    min, max = SIZES[archetype.to_sym][height]
    ranges = self.class.const_get("#{archetype.upcase}_RANGES")

    ratings = if test_archetype.nil?
      get_ratings(level, ranges.to_a, RATINGS)
    else
      get_test_ratings(level, ranges.to_a, RATINGS)
    end

    {
      "POS": "QB",
      "ARC": archetype,
      "AGE": get_age(level),
      "JEN": JERSEYS.sample,
      "HGT": height.to_s.to_i,
      "WGT": Kernel.rand(min..max),
      "OVR": OVERALLS[archetype.to_sym][level],
    }.merge(ratings)
  end


  protected

  def get_archetype(level, rand = Kernel.rand)
    cutoffs = ARCHETYPES[level]

    if rand >= cutoffs[0]
      "Balanced"
    elsif rand >= cutoffs[1]
      "Pocket"
    else
      "Scrambler"
    end
  end


  private

  ARCHETYPES = [[0.55, 0.1], [0.6, 0.2], [0.5, 0.25], [0.5, 0.25], [0.5, 0.25], [0.5, 0.25]].freeze

  JERSEYS = (1..19).to_a.freeze

  SIZES = {
    "Balanced": {"71": [201,209],"72": [205,213],"73": [209,217],"74": [213,221],"75": [217,225]},
    "Pocket": {"75": [220,230],"76": [225,235],"77": [230,240],"78": [235,245],"79": [240,250]},
    "Scrambler": {"74": [217,223],"75": [220,226],"76": [223,229]},
  }.freeze

  OVERALLS = {
    "Balanced": [76,73,68,64,60,56],
    "Pocket": [77,73,68,65,61,58],
    "Scrambler": [77,74,68,64,60,55],
  }.freeze

  BALANCED_RANGES = [
    {
      attributes: ["SPD","ACC","AGI","STR","CAR","BCV","BKT","TRK","SFA","ELU","SPM","JKM","THP","TOR","TUP","BSK","PLA","JUM"],
      ratings: [[5,7],[5,6],[4,6],[3,6],[3,5],[2,5]],
    },
    {
      attributes: ["SAC","MAC","DAC"],
      ratings: [[5,7],[5,6],[4,5],[3,5],[3,4],[2,4]],
    }
  ].freeze

  POCKET_RANGES = [
    {
      attributes: ["SPD","ACC","AGI","CAR","BCV","BKT","TRK","SFA","ELU","SPM","JKM","JUM"],
      ratings: [[3,4],[3,4],[2,4],[2,4],[2,3],[1,3]],
    },
    {
      attributes: ["SAC","MAC","DAC"],
      ratings: [[6,7],[5,7],[4,6],[4,5],[3,5],[3,4]],
    },
    {
      attributes: ["STR","THP","TOR","TUP","BSK","PLA"],
      ratings: [[4,7],[4,6],[3,6],[3,5],[3,4],[3,4]],
    }
  ].freeze

  SCRAMBLER_RANGES = [
    {
      attributes: ["SPD","ACC","AGI","ELU","JUM","TOR","TUP","BSK","PLA"],
      ratings: [[7,7],[6,7],[5,6],[4,6],[4,5],[4,5]],
    },
    {
      attributes: ["THP","SAC","MAC","DAC"],
      ratings: [[4,6],[4,5],[3,5],[2,5],[2,4],[1,4]],
    },
    {
      attributes: ["STR","CAR","BCV","BKT","TRK","SFA","SPM","JKM"],
      ratings: [[6,7],[5,7],[5,6],[4,6],[4,5],[4,5]],
    }
  ].freeze

  RATINGS = {
    "SPD": [58,89],
    "ACC": [53,88],
    "AGI": [60,91],
    "STR": [54,76],
    "AWR": [58,78],
    "CAR": [30,75],
    "BCV": [48,85],
    "BKT": [45,78],
    "TRK": [24,65],
    "SFA": [24,77],
    "ELU": [24,86],
    "SPM": [24,70],
    "JKM": [35,82],
    "CAT": [24,48],
    "CIT": [24,48],
    "SPC": [24,48],
    "SRR": [24,48],
    "MRR": [24,48],
    "DRR": [24,48],
    "REL": [24,48],
    "JUM": [58,86],
    "THP": [72,98],
    "SAC": [68,91],
    "MAC": [60,88],
    "DAC": [54,84],
    "TOR": [60,89],
    "TUP": [50,87],
    "BSK": [46,91],
    "PLA": [60,88],
    "PBL": [24,48],
    "PBP": [24,48],
    "PBF": [24,48],
    "RBL": [10,37],
    "RBP": [24,48],
    "RBF": [24,48],
    "LBK": [24,48],
    "IMP": [24,48],
    "PLR": [24,48],
    "TAK": [24,48],
    "HIT": [24,48],
    "BSG": [24,48],
    "FMV": [24,48],
    "PMV": [24,48],
    "PUR": [24,48],
    "MCV": [24,48],
    "ZCV": [24,48],
    "PRE": [24,48],
    "KRT": [24,48],
    "KPW": [24,48],
    "KAC": [24,48],
    "STA": [84,96],
    "TGH": [78,86],
    "INJ": [79,98],
  }.freeze
end
