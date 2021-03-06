class Create::Cornerback < Create::Player
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
      "POS": "CB",
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
      "Man"
    elsif rand >= cutoffs[2]
      "Zone"
    else
      "Slot"
    end
  end


  private

  ARCHETYPES = [[0.7, 0.35, 0], [0.7, 0.4, 0.1], [0.7, 0.5, 0.2], [0.7, 0.55, 0.25], [0.7, 0.6, 0.25], [0.75, 0.65, 0.25]].freeze

  JERSEYS = (20..39).to_a.freeze

  SIZES = {
    "Balanced": {"70": [185,195],"71": [190,200],"72": [195,205],"73": [200,210]},
    "Man": {"70": [175,185],"71": [180,190],"72": [185,195],"73": [190,200]},
    "Zone": {"72": [190,200],"73": [195,205],"74": [200,210],"75": [205,215]},
    "Slot": {"68": [170,180],"69": [175,185],"70": [180,190],"71": [185,195]},
  }.freeze

  OVERALLS = {
    "Balanced": [78,75,72,70,67,64],
    "Man": [78,76,74,70,67,63],
    "Zone": [78,75,73,70,67,63],
    "Slot": [78,76,73,70,67,63],
  }.freeze

  BALANCED_RANGES = [
    {
      attributes: ["SPD","ACC","AGI","ELU","CAT","JUM","MCV","ZCV","KRT"],
      ratings: [[5,6],[4,6],[3,5],[3,4],[2,3],[2,2]],
    },
    {
      attributes: ["STR","IMP","PLR","TAK","HIT","BSG","PUR","PRE"],
      ratings: [[4,5],[3,5],[3,4],[2,4],[2,3],[2,2]],
    }
  ].freeze

  MAN_RANGES = [
    {
      attributes: ["SPD","ACC","AGI","ELU","JUM","KRT"],
      ratings: [[6,7],[5,7],[5,6],[4,5],[4,4],[3,3]],
    },
    {
      attributes: ["STR","IMP","PLR","TAK","HIT","BSG","PUR","ZCV"],
      ratings: [[4,4],[3,4],[2,4],[2,3],[1,3],[1,2]],
    },
    {
      attributes: ["CAT","MCV"],
      ratings: [[5,7],[5,6],[4,6],[3,4],[2,3],[2,2]],
    },
    {
      attributes: ["PRE"],
      ratings: [[4,5],[4,4],[3,4],[3,3],[2,3],[2,2]],
    }
  ].freeze

  ZONE_RANGES = [
    {
      attributes: ["SPD","ACC","JUM","KRT"],
      ratings: [[4,5],[3,5],[3,4],[2,4],[2,3],[1,3]],
    },
    {
      attributes: ["STR","IMP","PLR","TAK","HIT","BSG","PUR"],
      ratings: [[6,7],[5,7],[5,6],[4,6],[4,5],[3,4]],
    },
    {
      attributes: ["CAT","ZCV","PRE"],
      ratings: [[6,7],[5,7],[4,6],[3,5],[2,4],[2,2]],
    },
    {
      attributes: ["AGI","ELU","MCV"],
      ratings: [[3,3],[2,3],[2,2],[2,2],[1,2],[1,1]],
    }
  ].freeze

  SLOT_RANGES = [
    {
      attributes: ["SPD","ACC","AGI","ELU","JUM","KRT"],
      ratings: [[5,6],[4,6],[3,5],[3,4],[2,3],[2,2]],
    },
    {
      attributes: ["STR","CAT","IMP","PLR","TAK","HIT","BSG","PUR"],
      ratings: [[7,7],[6,7],[5,6],[4,5],[3,5],[3,3]],
    },
    {
      attributes: ["MCV","ZCV","PRE"],
      ratings: [[4,4],[3,4],[3,3],[2,2],[1,2],[1,1]],
    }
  ].freeze

  RATINGS = {
    "SPD": [86,95],
    "ACC": [82,95],
    "AGI": [82,95],
    "STR": [50,73],
    "AWR": [52,77],
    "CAR": [26,84],
    "BCV": [29,77],
    "BKT": [24,48],
    "TRK": [24,70],
    "SFA": [24,48],
    "ELU": [77,96],
    "SPM": [29,72],
    "JKM": [32,81],
    "CAT": [45,75],
    "CIT": [24,48],
    "SPC": [24,48],
    "SRR": [24,48],
    "MRR": [24,48],
    "DRR": [24,48],
    "REL": [24,48],
    "JUM": [72,97],
    "THP": [10,38],
    "SAC": [10,37],
    "MAC": [10,37],
    "DAC": [10,37],
    "TOR": [10,37],
    "TUP": [24,48],
    "BSK": [24,48],
    "PLA": [24,48],
    "PBL": [24,48],
    "PBP": [24,48],
    "PBF": [24,48],
    "RBL": [10,37],
    "RBP": [24,48],
    "RBF": [24,48],
    "LBK": [24,48],
    "IMP": [45,61],
    "PLR": [52,77],
    "TAK": [59,74],
    "HIT": [58,77],
    "BSG": [39,61],
    "FMV": [24,48],
    "PMV": [24,48],
    "PUR": [59,77],
    "MCV": [58,81],
    "ZCV": [58,81],
    "PRE": [59,84],
    "KRT": [45,93],
    "KPW": [24,48],
    "KAC": [24,48],
    "STA": [84,96],
    "TGH": [78,86],
    "INJ": [80,98],
  }.freeze
end
