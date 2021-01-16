class Create::Player::Kicker < Create::Player::Base
  def call(level, test_archetype = nil)
    archetype = test_archetype.nil? ? get_archetype(level) : test_archetype
    height = SIZES.keys.sample
    min, max = SIZES[height]
    ranges = self.class.const_get("#{archetype.upcase}_RANGES")

    ratings = if test_archetype.nil?
      get_ratings(level, ranges.to_a, RATINGS)
    else
      get_test_ratings(level, ranges.to_a, RATINGS)
    end

    {
      "POS": ["K", get_position].join("-"),
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
      "Accurate"
    else
      "Power"
    end
  end

  def get_position(rand = Kernel.rand)
    rand >= 0.5 ? "K" : "P"
  end


  private

  ARCHETYPES = [[0.67, 0.33], [0.67, 0.33], [0.67, 0.33], [0.67, 0.33], [0.67, 0.33], [0.67, 0.33]].freeze

  JERSEYS = (1..9).to_a.freeze

  SIZES = {
    "68": [160,170],
    "69": [165,175],
    "70": [170,180],
    "71": [175,185],
    "72": [180,190],
    "73": [185,195],
    "74": [190,200],
    "75": [195,205],
    "76": [200,210]
  }.freeze

  OVERALLS = {
    "Balanced": [79,79,77,77,75,74],
    "Accurate": [80,79,78,77,76,73],
    "Power": [78,78,77,76,74,72],
  }.freeze

  BALANCED_RANGES = [
    {
      attributes: ["KPW","KAC"],
      ratings: [[6,6],[5,6],[4,6],[4,5],[3,4],[2,3]],
    }
  ].freeze

  ACCURATE_RANGES = [
    {
      attributes: ["KPW"],
      ratings: [[5,5],[4,5],[3,5],[3,4],[2,3],[1,2]],
    },
    {
      attributes: ["KAC"],
      ratings: [[7,7],[6,7],[5,7],[5,6],[4,5],[3,4]],
    }
  ].freeze

  POWER_RANGES = [
    {
      attributes: ["KPW"],
      ratings: [[7,7],[6,7],[5,7],[5,6],[4,5],[3,4]],
    },
    {
      attributes: ["KAC"],
      ratings: [[4,4],[4,4],[3,4],[2,3],[1,3],[1,1]],
    }
  ].freeze

  RATINGS = {
    "SPD": [60,76],
    "ACC": [64,76],
    "AGI": [50,59],
    "STR": [45,49],
    "AWR": [46,62],
    "CAR": [24,48],
    "BCV": [24,48],
    "BKT": [24,48],
    "TRK": [24,48],
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
    "JUM": [45,62],
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
    "KPW": [84,96],
    "KAC": [84,95],
    "STA": [84,96],
    "TGH": [78,86],
    "INJ": [82,93],
  }.freeze
end
