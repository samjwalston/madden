class Create::Linebacker < Create::Player
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
      "POS": ["LB", get_position(archetype)].join("-"),
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
      "OLB"
    else
      "RunStopper"
    end
  end

  def get_position(archetype, rand = Kernel.rand)
    if archetype.in?(["Balanced","RunStopper"])
      "MLB"
    else
      rand >= 0.5 ? "LOLB" : "ROLB"
    end
  end


  private

  ARCHETYPES = [[0.05, 0], [0.1, 0.05], [0.25, 0.1], [0.5, 0.2], [0.65, 0.3], [0.65, 0.3]].freeze

  JERSEYS = (40..59).to_a.freeze

  SIZES = {
    "Balanced": {"73": [225,235],"74": [230,240],"75": [235,245],"76": [240,250]},
    "OLB": {"73": [220,230],"74": [225,235]},
    "RunStopper": {"75": [235,245],"76": [240,250]},
  }.freeze

  OVERALLS = {
    "Balanced": [77,75,71,68,64,59],
    "OLB": [77,75,72,70,67,63],
    "RunStopper": [75,73,69,67,64,58],
  }.freeze

  BALANCED_RANGES = [
    {
      attributes: ["CAT","IMP","PLR","TAK","HIT","FMV","PMV","PUR","MCV","ZCV","PRE"],
      ratings: [[6,7],[5,7],[4,6],[3,5],[2,4],[1,3]],
    },
    {
      attributes: ["SPD","ACC","AGI","STR","ELU","JUM","BSG"],
      ratings: [[5,6],[4,6],[3,5],[3,4],[2,3],[2,3]],
    }
  ].freeze

  OLB_RANGES = [
    {
      attributes: ["IMP","PLR","TAK","HIT","PUR"],
      ratings: [[6,6],[5,6],[4,5],[3,5],[2,4],[1,3]],
    },
    {
      attributes: ["SPD","ACC","AGI","ELU","JUM"],
      ratings: [[7,7],[6,7],[5,7],[4,5],[4,4],[3,4]],
    },
    {
      attributes: ["STR","BSG","PMV"],
      ratings: [[2,2],[2,2],[1,2],[1,2],[1,1],[1,1]],
    },
    {
      attributes: ["CAT","FMV","MCV","ZCV","PRE"],
      ratings: [[6,7],[5,7],[5,6],[4,5],[4,4],[3,3]],
    }
  ].freeze

  RUNSTOPPER_RANGES = [
    {
      attributes: ["IMP","PLR","HIT","PUR"],
      ratings: [[6,7],[5,7],[4,6],[3,5],[2,4],[1,3]],
    },
    {
      attributes: ["STR","TAK","BSG","PMV"],
      ratings: [[7,7],[6,7],[5,6],[4,6],[4,5],[4,4]],
    },
    {
      attributes: ["SPD","ACC","AGI","ELU","CAT","JUM","FMV","MCV","ZCV","PRE"],
      ratings: [[4,4],[3,4],[3,3],[2,3],[2,2],[1,2]],
    }
  ].freeze

  RATINGS = {
    "SPD": [76,89],
    "ACC": [77,90],
    "AGI": [74,87],
    "STR": [58,77],
    "AWR": [54,77],
    "CAR": [24,48],
    "BCV": [24,48],
    "BKT": [24,48],
    "TRK": [24,48],
    "SFA": [24,48],
    "ELU": [55,84],
    "SPM": [24,48],
    "JKM": [24,48],
    "CAT": [39,63],
    "CIT": [24,48],
    "SPC": [24,48],
    "SRR": [24,48],
    "MRR": [24,48],
    "DRR": [24,48],
    "REL": [24,48],
    "JUM": [59,83],
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
    "IMP": [49,88],
    "PLR": [54,77],
    "TAK": [71,85],
    "HIT": [71,91],
    "BSG": [64,81],
    "FMV": [39,63],
    "PMV": [44,66],
    "PUR": [71,87],
    "MCV": [54,73],
    "ZCV": [56,75],
    "PRE": [39,67],
    "KRT": [24,48],
    "KPW": [24,48],
    "KAC": [24,48],
    "STA": [84,96],
    "TGH": [78,86],
    "INJ": [84,93],
  }.freeze
end
