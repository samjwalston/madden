class Create::Player::Edge < Create::Player::Base
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
      "POS": ["EDGE", get_position(archetype)].join("-"),
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
      "Hybrid"
    elsif rand >= cutoffs[1]
      "Speed"
    else
      "OLB"
    end
  end

  def get_position(archetype, rand = Kernel.rand)
    if archetype.in?(["Hybrid","Speed"])
      rand >= 0.5 ? "LE" : "RE"
    else
      rand >= 0.5 ? "LOLB" : "ROLB"
    end
  end


  private

  ARCHETYPES = [[1, 0.5], [0.9, 0.5], [0.9, 0.5], [0.8, 0.45], [0.8, 0.45], [0.75, 0.4]].freeze

  JERSEYS = [(50..59).to_a, (90..99).to_a].flatten.freeze

  SIZES = {
    "Hybrid": {"75": [270,276],"76": [273,279],"77": [276,282],"78": [279,285],"79": [282,289]},
    "Speed": {"75": [245,250],"76": [251,257],"77": [258,264],"78": [265,271]},
    "OLB": {"75": [242,348],"76": [249,255],"77": [256,262],"78": [263,269]},
  }.freeze

  OVERALLS = {
    "Hybrid": [77,75,70,68,63,58],
    "Speed": [77,74,71,68,65,61],
    "OLB": [77,74,71,68,64,60],
  }.freeze

  HYBRID_RANGES = [
    {
      attributes: ["IMP","PLR","TAK","HIT","PUR"],
      ratings: [[6,7],[5,7],[4,6],[3,5],[2,4],[1,3]],
    },
    {
      attributes: ["SPD","ACC","AGI","ELU","FMV"],
      ratings: [[4,4],[3,4],[2,3],[2,2],[1,2],[1,1]],
    },
    {
      attributes: ["STR","BSG","PMV"],
      ratings: [[6,7],[5,7],[4,6],[4,5],[4,5],[4,4]],
    },
    {
      attributes: ["MCV","ZCV"],
      ratings: [[2,2],[2,2],[1,2],[1,2],[1,1],[1,1]],
    }
  ].freeze

  SPEED_RANGES = [
    {
      attributes: ["IMP","PLR","TAK","HIT","PUR"],
      ratings: [[5,6],[4,6],[4,5],[3,5],[2,4],[1,3]],
    },
    {
      attributes: ["SPD","ACC","AGI","ELU","FMV"],
      ratings: [[5,7],[5,6],[4,5],[3,4],[3,3],[2,3]],
    },
    {
      attributes: ["STR","BSG","PMV"],
      ratings: [[5,5],[4,4],[3,4],[3,3],[2,3],[1,3]],
    },
    {
      attributes: ["MCV","ZCV"],
      ratings: [[4,4],[3,4],[3,3],[2,3],[2,2],[1,2]],
    }
  ].freeze

  OLB_RANGES = [
    {
      attributes: ["IMP","PLR","TAK","HIT","PUR"],
      ratings: [[5,6],[4,6],[4,5],[3,5],[2,4],[1,3]],
    },
    {
      attributes: ["SPD","ACC","AGI","ELU","FMV"],
      ratings: [[5,7],[5,6],[4,5],[3,4],[3,3],[2,3]],
    },
    {
      attributes: ["STR","BSG","PMV"],
      ratings: [[4,5],[3,5],[3,4],[2,4],[2,3],[1,3]],
    },
    {
      attributes: ["MCV","ZCV"],
      ratings: [[6,7],[5,7],[5,6],[4,6],[4,5],[4,4]],
    }
  ].freeze

  RATINGS = {
    "SPD": [70,88],
    "ACC": [71,89],
    "AGI": [69,87],
    "STR": [60,83],
    "AWR": [48,78],
    "CAR": [24,48],
    "BCV": [24,48],
    "BKT": [24,48],
    "TRK": [24,48],
    "SFA": [24,48],
    "ELU": [55,84],
    "SPM": [24,48],
    "JKM": [24,48],
    "CAT": [45,62],
    "CIT": [24,48],
    "SPC": [24,48],
    "SRR": [24,48],
    "MRR": [24,48],
    "DRR": [24,48],
    "REL": [24,48],
    "JUM": [58,87],
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
    "IMP": [55,84],
    "PLR": [48,78],
    "TAK": [69,86],
    "HIT": [71,89],
    "BSG": [60,80],
    "FMV": [61,85],
    "PMV": [62,83],
    "PUR": [69,87],
    "MCV": [39,60],
    "ZCV": [39,63],
    "PRE": [24,48],
    "KRT": [24,48],
    "KPW": [24,48],
    "KAC": [24,48],
    "STA": [70,96],
    "TGH": [77,86],
    "INJ": [80,98],
  }.freeze
end
