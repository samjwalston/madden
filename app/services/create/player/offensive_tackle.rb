class Create::Player::OffensiveTackle < Create::Player::Base
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
      "POS": ["OT", get_position].join("-"),
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
      "Finesse"
    else
      "Mauler"
    end
  end

  def get_position(rand = Kernel.rand)
    if rand >= 0.5
      "LT"
    else
      "RT"
    end
  end


  private

  ARCHETYPES = [[0.6, 0.2], [0.6, 0.2], [0.6, 0.2], [0.6, 0.2], [0.6, 0.2], [0.6, 0.2]].freeze

  JERSEYS = (60..79).to_a.freeze

  SIZES = {
    "Balanced": {"76": [295,305],"77": [305,315],"78": [315,325],"79": [325,335]},
    "Finesse": {"77": [290,300],"78": [295,305],"79": [300,310],"80": [305,315]},
    "Mauler": {"78": [315,325],"79": [325,335],"80": [335,345]},
  }.freeze

  OVERALLS = {
    "Balanced": [76,73,69,66,62,57],
    "Finesse": [76,73,69,67,64,60],
    "Mauler": [75,73,69,67,63,59],
  }.freeze

  BALANCED_RANGES = [
    {
      attributes: ["SPD","ACC","AGI","STR","JUM"],
      ratings: [[5,6],[4,6],[4,5],[3,5],[3,4],[2,4]],
    },
    {
      attributes: ["PBL","PBP","PBF","RBL","RBP","RBF"],
      ratings: [[6,7],[5,7],[4,5],[3,5],[2,3],[1,3]],
    },
    {
      attributes: ["TRK","LBK","IMP"],
      ratings: [[5,6],[4,5],[3,4],[2,4],[2,3],[1,3]],
    }
  ].freeze

  FINESSE_RANGES = [
    {
      attributes: ["SPD","ACC","AGI","JUM","LBK","IMP"],
      ratings: [[7,7],[6,7],[5,6],[4,6],[4,5],[4,4]],
    },
    {
      attributes: ["PBL","PBF","RBF"],
      ratings: [[7,7],[5,7],[4,6],[4,5],[3,4],[3,3]],
    },
    {
      attributes: ["STR","TRK","PBP","RBL","RBP"],
      ratings: [[5,5],[4,5],[3,4],[2,4],[2,3],[1,3]],
    }
  ].freeze

  MAULER_RANGES = [
    {
      attributes: ["SPD","ACC","AGI","JUM","PBF","LBK"],
      ratings: [[4,4],[3,4],[3,3],[2,3],[2,2],[1,2]],
    },
    {
      attributes: ["PBL","PBP","RBP"],
      ratings: [[6,6],[5,6],[4,5],[3,5],[2,4],[1,4]],
    },
    {
      attributes: ["STR","TRK","RBL","RBF","IMP"],
      ratings: [[7,7],[5,7],[4,6],[4,5],[3,4],[3,3]],
    }
  ].freeze

  RATINGS = {
    "SPD": [58,77],
    "ACC": [53,84],
    "AGI": [57,75],
    "STR": [79,95],
    "AWR": [54,78],
    "CAR": [24,48],
    "BCV": [24,48],
    "BKT": [24,48],
    "TRK": [30,62],
    "SFA": [24,48],
    "ELU": [24,48],
    "SPM": [24,48],
    "JKM": [24,48],
    "CAT": [24,48],
    "CIT": [24,48],
    "SPC": [24,48],
    "SRR": [24,48],
    "MRR": [24,48],
    "DRR": [24,48],
    "REL": [24,48],
    "JUM": [46,84],
    "THP": [10,38],
    "SAC": [10,37],
    "MAC": [10,37],
    "DAC": [10,37],
    "TOR": [10,37],
    "TUP": [24,48],
    "BSK": [24,48],
    "PLA": [24,48],
    "PBL": [57,81],
    "PBP": [57,81],
    "PBF": [57,81],
    "RBL": [57,81],
    "RBP": [57,81],
    "RBF": [57,81],
    "LBK": [65,87],
    "IMP": [65,87],
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
    "INJ": [80,98],
  }.freeze
end
