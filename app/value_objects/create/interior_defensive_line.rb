class Create::InteriorDefensiveLine < Create::Player
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
      "POS": ["IDL", get_position(archetype)].join("-"),
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
      "NoseTackle"
    elsif rand >= cutoffs[2]
      "Speed"
    else
      "Power"
    end
  end

  def get_position(archetype, rand = Kernel.rand)
    if archetype == "Balanced"
      if rand >= 0.6
        "DT"
      elsif rand >= 0.3
        "LE"
      else
        "RE"
      end
    elsif archetype == "NoseTackle"
      "DT"
    elsif archetype == "Speed"
      rand >= 0.5 ? "LE" : "RE"
    elsif archetype == "Power"
      if rand >= 0.5
        "DT"
      elsif rand >= 0.25
        "LE"
      else
        "RE"
      end
    end
  end


  private

  ARCHETYPES = [[0.5, 0.4, 0.2], [0.6, 0.5, 0.25], [0.7, 0.5, 0.25], [0.75, 0.5, 0.25], [0.8, 0.5, 0.25], [0.9, 0.6, 0.3]].freeze

  JERSEYS = [(70..79).to_a, (90..99).to_a].flatten.freeze

  SIZES = {
    "Balanced": {"73": [295,300],"74": [300,305],"75": [305,310],"76": [310,315],"77": [315,320]},
    "NoseTackle": {"74": [315,320],"75": [320,325],"76": [325,330],"77": [330,335],"78": [335,340]},
    "Speed": {"72": [290,294],"73": [294,298],"74": [298,302],"75": [302,306],"76": [306,310]},
    "Power": {"74": [310,315],"75": [315,320],"76": [320,325],"77": [325,330]},
  }.freeze

  OVERALLS = {
    "Balanced": [78,75,72,69,65,59],
    "NoseTackle": [79,77,74,71,68,63],
    "Speed": [77,75,70,67,63,59],
    "Power": [77,75,70,67,64,59],
  }.freeze

  BALANCED_RANGES = [
    {
      attributes: ["IMP","PLR","TAK","HIT","PUR"],
      ratings: [[6,7],[5,7],[4,6],[3,5],[2,4],[1,3]],
    },
    {
      attributes: ["SPD","ACC","AGI","ELU"],
      ratings: [[6,7],[5,7],[4,6],[4,5],[3,4],[3,4]],
    },
    {
      attributes: ["STR","BSG"],
      ratings: [[4,5],[3,5],[3,4],[2,4],[2,3],[1,3]],
    },
    {
      attributes: ["FMV","PMV"],
      ratings: [[6,6],[5,6],[4,5],[3,5],[2,4],[2,3]],
    }
  ].freeze

  NOSETACKLE_RANGES = [
    {
      attributes: ["IMP","PLR","TAK","HIT","PUR"],
      ratings: [[6,7],[5,7],[4,6],[3,5],[2,4],[1,3]],
    },
    {
      attributes: ["SPD","ACC","AGI","ELU","PMV"],
      ratings: [[3,3],[3,3],[2,3],[2,2],[1,2],[1,1]],
    },
    {
      attributes: ["STR","BSG"],
      ratings: [[6,7],[5,6],[4,6],[4,5],[4,5],[4,4]],
    },
    {
      attributes: ["FMV"],
      ratings: [[2,2],[2,2],[1,2],[1,2],[1,1],[1,1]],
    }
  ].freeze

  SPEED_RANGES = [
    {
      attributes: ["IMP","PLR","TAK","HIT","PUR"],
      ratings: [[6,7],[5,7],[4,6],[3,5],[2,4],[1,3]],
    },
    {
      attributes: ["SPD","ACC","AGI","ELU","FMV"],
      ratings: [[7,7],[6,7],[5,6],[4,6],[4,5],[4,4]],
    },
    {
      attributes: ["STR","BSG"],
      ratings: [[3,3],[3,3],[2,3],[2,2],[1,2],[1,1]],
    },
    {
      attributes: ["PMV"],
      ratings: [[4,5],[3,5],[2,4],[2,3],[1,3],[1,2]],
    }
  ].freeze

  POWER_RANGES = [
    {
      attributes: ["IMP","PLR","TAK","HIT","PUR"],
      ratings: [[6,7],[5,7],[4,6],[3,5],[2,4],[1,3]],
    },
    {
      attributes: ["SPD","ACC","PMV"],
      ratings: [[6,7],[5,7],[4,6],[4,5],[4,5],[4,4]],
    },
    {
      attributes: ["STR","BSG","FMV"],
      ratings: [[4,4],[3,4],[2,3],[2,2],[1,2],[1,1]],
    },
    {
      attributes: ["AGI","ELU"],
      ratings: [[4,4],[4,4],[3,4],[3,3],[2,3],[2,2]],
    }
  ].freeze

  RATINGS = {
    "SPD": [55,79],
    "ACC": [59,85],
    "AGI": [61,77],
    "STR": [79,97],
    "AWR": [48,78],
    "CAR": [24,48],
    "BCV": [24,48],
    "BKT": [24,48],
    "TRK": [24,48],
    "SFA": [24,48],
    "ELU": [55,70],
    "SPM": [24,48],
    "JKM": [24,48],
    "CAT": [45,62],
    "CIT": [24,48],
    "SPC": [24,48],
    "SRR": [24,48],
    "MRR": [24,48],
    "DRR": [24,48],
    "REL": [24,48],
    "JUM": [56,86],
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
    "IMP": [49,89],
    "PLR": [48,78],
    "TAK": [68,84],
    "HIT": [68,84],
    "BSG": [63,83],
    "FMV": [54,83],
    "PMV": [57,88],
    "PUR": [68,82],
    "MCV": [24,48],
    "ZCV": [24,48],
    "PRE": [24,48],
    "KRT": [24,48],
    "KPW": [24,48],
    "KAC": [24,48],
    "STA": [60,95],
    "TGH": [77,86],
    "INJ": [79,98],
  }.freeze
end
