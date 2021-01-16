class Create::Player::Safety < Create::Player::Base
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
      "POS": ["S", get_position(archetype)].join("-"),
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
      "Center"
    else
      "Box"
    end
  end

  def get_position(archetype, rand = Kernel.rand)
    if archetype == "Center"
      "FS"
    elsif archetype == "Box"
      "SS"
    else
      rand >= 0.5 ? "FS" : "SS"
    end
  end

  private

  ARCHETYPES = [[0.2, 0], [0.3, 0.1], [0.4, 0.2], [0.5, 0.25], [0.5, 0.25], [0.5, 0.25]].freeze

  JERSEYS = (20..49).to_a.freeze

  SIZES = {
    "Balanced": {"70": [185,195],"71": [190,200],"72": [195,205],"73": [200,210],"74": [205,215]},
    "Center": {"70": [175,185],"71": [180,190],"72": [185,195],"73": [190,200],"74": [195,205]},
    "Box": {"71": [200,210],"72": [205,215],"73": [210,220],"74": [215,225],"75": [220,230]},
  }.freeze

  OVERALLS = {
    "Balanced": [77,74,70,68,64,61],
    "Center": [77,75,71,69,66,63],
    "Box": [76,74,71,69,65,61],
  }.freeze

  BALANCED_RANGES = [
    {
      attributes: ["SPD","ACC","AGI","ELU","CAT","JUM","MCV","ZCV","PRE"],
      ratings: [[6,6],[4,6],[3,5],[3,4],[2,3],[2,2]],
    },
    {
      attributes: ["STR","IMP","PLR","TAK","HIT","BSG","PUR"],
      ratings: [[6,6],[5,6],[4,5],[3,4],[2,3],[2,2]],
    }
  ].freeze

  CENTER_RANGES = [
    {
      attributes: ["SPD","ACC","AGI","ELU","CAT","JUM","ZCV"],
      ratings: [[7,7],[6,7],[5,6],[4,6],[4,5],[4,4]],
    },
    {
      attributes: ["STR","IMP","TAK","HIT","BSG"],
      ratings: [[4,4],[3,4],[2,3],[2,2],[1,2],[1,1]],
    },
    {
      attributes: ["PLR","PUR","MCV","PRE"],
      ratings: [[6,6],[5,6],[4,5],[3,4],[2,3],[2,2]],
    }
  ].freeze

  BOX_RANGES = [
    {
      attributes: ["SPD","ACC","AGI","ELU","JUM"],
      ratings: [[5,5],[4,5],[3,4],[3,3],[2,2],[1,1]],
    },
    {
      attributes: ["STR","IMP","PLR","TAK","HIT","BSG","PUR","PRE"],
      ratings: [[7,7],[6,7],[5,7],[5,6],[4,6],[4,5]],
    },
    {
      attributes: ["CAT","MCV","ZCV"],
      ratings: [[4,4],[3,4],[2,3],[2,2],[1,2],[1,1]],
    }
  ].freeze

  RATINGS = {
    "SPD": [83,93],
    "ACC": [83,93],
    "AGI": [82,91],
    "STR": [50,73],
    "AWR": [50,75],
    "CAR": [57,74],
    "BCV": [25,76],
    "BKT": [24,48],
    "TRK": [45,70],
    "SFA": [40,65],
    "ELU": [71,92],
    "SPM": [28,72],
    "JKM": [44,72],
    "CAT": [45,76],
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
    "IMP": [55,67],
    "PLR": [50,75],
    "TAK": [59,79],
    "HIT": [57,88],
    "BSG": [39,63],
    "FMV": [24,48],
    "PMV": [24,48],
    "PUR": [61,82],
    "MCV": [62,76],
    "ZCV": [59,77],
    "PRE": [60,76],
    "KRT": [20,95],
    "KPW": [24,48],
    "KAC": [24,48],
    "STA": [84,96],
    "TGH": [78,86],
    "INJ": [82,98],
  }.freeze
end
