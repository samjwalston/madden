class Create::Player::TightEnd < Create::Player::Base
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
      "POS": archetype == "Fullback" ? "FB" : "TE",
      "ARC": archetype,
      "AGE": get_age(level),
      "JEN": archetype == "Fullback" ? FB_JERSEYS.sample : TE_JERSEYS.sample,
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
      "Receiver"
    elsif rand >= cutoffs[2]
      "Blocker"
    else
      "Fullback"
    end
  end


  private

  ARCHETYPES = [[0.2, 0, 0], [0.5, 0, 0], [0.55, 0.1, 0.05], [0.65, 0.3, 0.15], [0.7, 0.4, 0.2], [0.75, 0.5, 0.25]].freeze

  FB_JERSEYS = (30..49).to_a.freeze
  TE_JERSEYS = (80..89).to_a.freeze

  SIZES = {
    "Balanced": {"75": [234,246],"76": [240,252],"77": [246,258],"78": [252,264]},
    "Receiver": {"75": [234,246],"76": [240,252],"77": [246,258],"78": [252,264]},
    "Blocker": {"76": [242,254],"77": [254,266],"78": [266,278]},
    "Fullback": {"74": [235,245],"75": [245,255]},
  }.freeze

  OVERALLS = {
    "Balanced": [78,73,71,66,63,60],
    "Receiver": [78,76,73,69,66,61],
    "Blocker": [79,79,76,72,69,65],
    "Fullback": [74,74,70,69,65,61],
  }.freeze

  BALANCED_RANGES = [
    {
      attributes: ["SPD","ACC","AGI","ELU","JUM"],
      ratings: [[6,7],[5,6],[5,5],[4,4],[3,4],[3,3]],
    },
    {
      attributes: ["CAT","CIT","SPC"],
      ratings: [[5,6],[4,6],[4,5],[3,4],[2,4],[2,3]],
    },
    {
      attributes: ["SRR","MRR","DRR","REL"],
      ratings: [[6,6],[5,5],[4,5],[4,4],[3,4],[2,4]],
    },
    {
      attributes: ["STR","CAR","BCV","BKT","TRK","SFA","SPM","JKM","PBL","PBP","PBF","RBL","RBP","RBF","LBK","IMP"],
      ratings: [[5,6],[4,5],[4,4],[3,4],[2,4],[2,3]],
    }
  ].freeze

  RECEIVER_RANGES = [
    {
      attributes: ["SPD","ACC","AGI","ELU","JUM"],
      ratings: [[6,7],[6,7],[6,6],[6,6],[5,6],[5,5]],
    },
    {
      attributes: ["CAR","BCV","BKT","TRK","SFA","SPM","JKM","CAT","CIT","SPC","SRR","MRR","DRR","REL"],
      ratings: [[5,7],[5,6],[4,6],[3,5],[3,4],[2,4]],
    },
    {
      attributes: ["STR","PBL","PBP","PBF","RBL","RBP","RBF","LBK","IMP"],
      ratings: [[4,5],[3,5],[3,4],[2,4],[2,3],[1,3]],
    }
  ].freeze

  BLOCKER_RANGES = [
    {
      attributes: ["SPD","ACC","AGI","CAR","BCV","BKT","TRK","SFA","ELU","SPM","JKM","CAT","CIT","SPC","SRR","MRR","DRR","REL","JUM"],
      ratings: [[3,3],[3,3],[2,3],[2,2],[1,2],[1,1]],
    },
    {
      attributes: ["STR","PBL","PBP","PBF","RBL","RBP","RBF","LBK","IMP"],
      ratings: [[7,7],[7,7],[6,7],[6,6],[5,6],[4,6]],
    }
  ].freeze

  FULLBACK_RANGES = [
    {
      attributes: ["SPD","ACC","AGI","CAR","BCV","BKT","TRK","SFA","ELU","SPM","JKM","CAT","CIT","SPC","JUM"],
      ratings: [[5,5],[5,5],[4,5],[3,5],[3,4],[2,4]],
    },
    {
      attributes: ["SRR","MRR","DRR","REL"],
      ratings: [[4,4],[4,4],[3,4],[2,4],[2,3],[1,3]],
    },
    {
      attributes: ["STR","PBL","PBP","PBF","RBL","RBP","RBF","LBK","IMP"],
      ratings: [[6,6],[6,6],[5,6],[5,6],[4,6],[4,5]],
    }
  ].freeze

  RATINGS = {
    "SPD": [63,87],
    "ACC": [58,88],
    "AGI": [68,84],
    "STR": [56,85],
    "AWR": [45,72],
    "CAR": [43,80],
    "BCV": [45,74],
    "BKT": [45,74],
    "TRK": [50,86],
    "SFA": [56,87],
    "ELU": [43,82],
    "SPM": [44,71],
    "JKM": [38,77],
    "CAT": [58,86],
    "CIT": [58,90],
    "SPC": [45,82],
    "SRR": [50,75],
    "MRR": [45,72],
    "DRR": [32,67],
    "REL": [54,80],
    "JUM": [45,93],
    "THP": [10,38],
    "SAC": [10,37],
    "MAC": [10,37],
    "DAC": [10,37],
    "TOR": [10,37],
    "TUP": [24,48],
    "BSK": [24,48],
    "PLA": [24,48],
    "PBL": [47,74],
    "PBP": [42,68],
    "PBF": [42,68],
    "RBL": [47,74],
    "RBP": [42,68],
    "RBF": [42,68],
    "LBK": [53,75],
    "IMP": [53,75],
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
    "KRT": [20,39],
    "KPW": [24,48],
    "KAC": [24,48],
    "STA": [84,96],
    "TGH": [78,86],
    "INJ": [84,97],
  }.freeze
end
