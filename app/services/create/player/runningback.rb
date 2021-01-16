class Create::Player::Runningback < Create::Player::Base
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
      "POS": "HB",
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
      "Speed"
    elsif rand >= cutoffs[2]
      "Bruiser"
    else
      "Receiving"
    end
  end


  private

  ARCHETYPES = [[0.4, 0.3, 0], [0.5, 0.4, 0.1], [0.6, 0.45, 0.15], [0.7, 0.45, 0.15], [0.7, 0.45, 0.15], [0.7, 0.45, 0.15]].freeze

  JERSEYS = (20..39).to_a.freeze

  SIZES = {
    "Balanced": {"69": [212,218],"70": [215,221],"71": [218,224],"72": [221,227],"73": [224,230]},
    "Speed": {"70": [194,200],"71": [197,203],"72": [200,206]},
    "Bruiser": {"70": [217,223],"71": [220,226],"72": [223,229],"73": [226,232],"74": [229,235],"75": [232,238]},
    "Receiving": {"67": [177,183],"68": [183,189],"69": [189,195],"70": [195,201],"71": [201,207]},
  }.freeze

  OVERALLS = {
    "Balanced": [78,74,69,66,61,56],
    "Speed": [77,73,68,65,63,57],
    "Bruiser": [77,72,68,63,61,56],
    "Receiving": [77,73,68,66,63,57],
  }.freeze

  BALANCED_RANGES = [
    {
      attributes: ["BCV","JUM"],
      ratings: [[6,7],[5,7],[4,6],[3,6],[2,5],[1,5]],
    },
    {
      attributes: ["SPD","ACC","AGI","STR","CAR","BKT","TRK","SFA","ELU","SPM","JKM","CAT","CIT","SPC","SRR","MRR","DRR","REL","PBL","KRT"],
      ratings: [[6,6],[5,6],[4,6],[4,5],[3,5],[3,4]],
    }
  ].freeze

  SPEED_RANGES = [
    {
      attributes: ["BCV","JUM"],
      ratings: [[6,7],[5,7],[4,6],[3,6],[2,5],[1,5]],
    },
    {
      attributes: ["SPD","ACC","AGI","ELU","SPM","JKM","KRT"],
      ratings: [[6,7],[5,7],[5,6],[4,6],[4,6],[4,5]],
    },
    {
      attributes: ["STR","CAR","BKT","TRK","SFA","PBL"],
      ratings: [[3,5],[3,5],[2,4],[2,4],[2,3],[1,3]],
    },
    {
      attributes: ["CAT","CIT","SPC","SRR","MRR","DRR","REL"],
      ratings: [[3,6],[3,5],[3,4],[2,4],[2,3],[1,3]],
    }
  ].freeze

  BRUISER_RANGES = [
    {
      attributes: ["BCV","JUM"],
      ratings: [[6,7],[5,7],[4,6],[3,6],[2,5],[1,5]],
    },
    {
      attributes: ["SPD","ACC","AGI","ELU","SPM","JKM","CAT","CIT","SPC","SRR","MRR","DRR","REL","KRT"],
      ratings: [[4,5],[3,5],[3,4],[2,4],[2,3],[1,3]],
    },
    {
      attributes: ["STR","CAR","BKT","TRK","SFA","PBL"],
      ratings: [[7,7],[6,7],[5,7],[5,6],[5,6],[5,6]],
    }
  ].freeze


  RECEIVING_RANGES = [
    {
      attributes: ["BCV","JUM"],
      ratings: [[6,7],[5,7],[4,6],[3,6],[2,5],[1,5]],
    },
    {
      attributes: ["SPD","ACC","AGI","ELU","SPM","JKM","KRT"],
      ratings: [[6,6],[5,6],[4,6],[4,5],[4,5],[3,5]],
    },
    {
      attributes: ["STR","CAR","BKT","TRK","SFA","PBL"],
      ratings: [[4,4],[3,4],[2,4],[2,4],[2,3],[1,3]],
    },
    {
      attributes: ["CAT","CIT","SPC","SRR","MRR","DRR","REL"],
      ratings: [[7,7],[6,7],[6,7],[5,7],[5,6],[4,6]],
    }
  ].freeze

  RATINGS = {
    "SPD": [79,94],
    "ACC": [80,93],
    "AGI": [71,93],
    "STR": [54,86],
    "AWR": [54,76],
    "CAR": [72,92],
    "BCV": [67,90],
    "BKT": [45,88],
    "TRK": [38,91],
    "SFA": [38,86],
    "ELU": [46,88],
    "SPM": [51,88],
    "JKM": [46,85],
    "CAT": [54,86],
    "CIT": [48,76],
    "SPC": [46,73],
    "SRR": [48,79],
    "MRR": [41,67],
    "DRR": [34,55],
    "REL": [24,48],
    "JUM": [68,91],
    "THP": [10,38],
    "SAC": [10,37],
    "MAC": [10,37],
    "DAC": [10,37],
    "TOR": [10,37],
    "TUP": [24,48],
    "BSK": [24,48],
    "PLA": [24,48],
    "PBL": [43,72],
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
    "KRT": [45,93],
    "KPW": [24,48],
    "KAC": [24,48],
    "STA": [84,96],
    "TGH": [78,86],
    "INJ": [79,96],
  }.freeze
end
