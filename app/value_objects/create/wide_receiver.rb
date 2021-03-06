class Create::WideReceiver < Create::Player
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
      "POS": "WR",
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
      "DeepThreat"
    elsif rand >= cutoffs[2]
      "Slot"
    else
      "RedZone"
    end
  end


  private

  ARCHETYPES = [[0.1, 0, 0], [0.2, 0.1, 0.05], [0.3, 0.2, 0.1], [0.4, 0.25, 0.1], [0.4, 0.25, 0.1], [0.4, 0.25, 0.1]].freeze

  JERSEYS = [(10..19).to_a, (80..89).to_a].flatten.freeze

  SIZES = {
    "Balanced": {"70": [185,195],"71": [190,200],"72": [195,205],"73": [200,210],"74": [205,215]},
    "DeepThreat": {"69": [170,180],"70": [175,185],"71": [180,190],"72": [185,195],"73": [190,200],"74": [195,205],"75": [200,210],"76": [205,215]},
    "RedZone": {"76": [210,220],"77": [215,225],"78": [220,230]},
    "Slot": {"69": [190,200],"70": [195,205],"71": [200,210],"72": [205,215]},
  }.freeze

  OVERALLS = {
    "Balanced": [75,73,70,67,63,62],
    "DeepThreat": [79,74,71,69,66,64],
    "RedZone": [79,75,71,68,65,59],
    "Slot": [78,75,72,68,65,62],
  }.freeze

  BALANCED_RANGES = [
    {
      attributes: ["CAT","CIT","SPC","MRR"],
      ratings: [[4,6],[4,5],[3,5],[3,4],[2,4],[2,4]],
    },
    {
      attributes: ["DRR"],
      ratings: [[4,5],[3,5],[3,4],[2,3],[1,3],[1,1]],
    },
    {
      attributes: ["SPD","ACC","AGI","ELU","JUM"],
      ratings: [[4,6],[4,6],[4,5],[4,5],[4,4],[4,4]],
    },
    {
      attributes: ["CAR","BCV","SPM","JKM","SRR","KRT"],
      ratings: [[4,6],[4,5],[4,5],[3,5],[3,4],[3,4]],
    },
    {
      attributes: ["STR","BKT","TRK","SFA","REL","PBL","RBL","IMP"],
      ratings: [[6,6],[5,6],[5,6],[4,6],[4,5],[3,5]],
    }
  ].freeze

  DEEPTHREAT_RANGES = [
    {
      attributes: ["CAR","BCV","SPM","JKM","CAT","CIT","SPC","MRR","KRT"],
      ratings: [[4,5],[3,5],[3,4],[3,4],[2,4],[2,3]],
    },
    {
      attributes: ["SPD","ACC","AGI","ELU","DRR","REL","JUM"],
      ratings: [[6,7],[5,6],[5,5],[4,5],[4,4],[4,4]],
    },
    {
      attributes: ["STR","BKT","TRK","SFA","SRR","PBL","RBL","IMP"],
      ratings: [[4,4],[3,4],[3,3],[2,3],[2,2],[1,2]],
    }
  ].freeze

  REDZONE_RANGES = [
    {
      attributes: ["CAT","CIT","SPC","REL"],
      ratings: [[6,7],[5,7],[5,6],[4,6],[4,5],[3,5]],
    },
    {
      attributes: ["SPD","ACC","AGI","ELU","SRR","MRR","JUM"],
      ratings: [[5,5],[4,5],[3,5],[3,4],[2,4],[1,4]],
    },
    {
      attributes: ["CAR","BCV","SPM","JKM","DRR","KRT"],
      ratings: [[3,3],[2,3],[1,3],[1,2],[1,2],[1,1]],
    },
    {
      attributes: ["STR","BKT","TRK","SFA","PBL","RBL","IMP"],
      ratings: [[7,7],[6,7],[5,7],[5,6],[5,6],[5,5]],
    }
  ].freeze

  SLOT_RANGES = [
    {
      attributes: ["SPD","CAT","MRR","KRT"],
      ratings: [[4,5],[4,4],[3,4],[3,3],[2,3],[2,2]],
    },
    {
      attributes: ["ACC","AGI","CAR","BCV","ELU","SPM","JKM","CIT","SRR","JUM"],
      ratings: [[6,7],[5,7],[5,6],[4,6],[4,5],[4,4]],
    },
    {
      attributes: ["STR","BKT","TRK","SFA","PBL","RBL","IMP"],
      ratings: [[6,6],[5,6],[5,6],[4,6],[4,5],[3,5]],
    },
    {
      attributes: ["SPC","DRR","REL"],
      ratings: [[3,4],[3,3],[2,3],[2,2],[1,2],[1,1]],
    }
  ].freeze

  RATINGS = {
    "SPD": [82,98],
    "ACC": [83,97],
    "AGI": [80,98],
    "STR": [46,80],
    "AWR": [50,78],
    "CAR": [59,83],
    "BCV": [49,85],
    "BKT": [52,82],
    "TRK": [39,80],
    "SFA": [38,82],
    "ELU": [74,89],
    "SPM": [57,85],
    "JKM": [47,87],
    "CAT": [65,89],
    "CIT": [60,88],
    "SPC": [58,92],
    "SRR": [58,93],
    "MRR": [57,90],
    "DRR": [56,87],
    "REL": [54,89],
    "JUM": [56,96],
    "THP": [10,38],
    "SAC": [10,37],
    "MAC": [10,37],
    "DAC": [10,37],
    "TOR": [10,37],
    "TUP": [24,48],
    "BSK": [24,48],
    "PLA": [24,48],
    "PBL": [40,60],
    "PBP": [24,48],
    "PBF": [24,48],
    "RBL": [40,60],
    "RBP": [24,48],
    "RBF": [24,48],
    "LBK": [24,48],
    "IMP": [40,60],
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
    "KRT": [62,94],
    "KPW": [24,48],
    "KAC": [24,48],
    "STA": [84,96],
    "TGH": [78,86],
    "INJ": [80,98],
  }.freeze
end
