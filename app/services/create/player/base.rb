class Create::Player::Base < ApplicationService
  protected

  def get_rating_ranges(min, max, mins = [], maxs = [])
    step = ((max - min).to_d / 7.to_d).floor

    7.times do |n|
      m = (max - (n * step))
      mins << (n.zero? ? nil : (m + 1))
      maxs << m
    end

    (mins << min).compact.reverse.zip(maxs.reverse)
  end

  def get_rating(min, max)
    mean = ((min + max) / 2.0)
    stddev = (max - min) / 5.0
    val = gaussian(mean, stddev)

    [max, [min, gaussian(mean, stddev).round.to_i].max].min
  end

  def get_age(level, rand = Kernel.rand)
    cutoffs = AGES[level]

    if rand >= cutoffs[0]
      20
    elsif rand >= cutoffs[1]
      21
    elsif rand >= cutoffs[2]
      22
    elsif rand >= cutoffs[3]
      23
    else
      24
    end
  end

  def get_ratings(level, ranges, ratings)
    get_data(level, ranges).map do |attribute, values|
      range = get_rating_ranges(*ratings[attribute.to_sym])
      min = range[values.first - 1].first
      max = range[values.last - 1].last

      [attribute, get_rating(min, max)]
    end.to_h
  end

  def get_test_ratings(level, ranges, ratings)
    get_data(level, ranges).map do |attribute, values|
      range = get_rating_ranges(*ratings[attribute.to_sym])
      min = range[values.first - 1].first
      max = range[values.last - 1].last

      [attribute, ((min + max) / 2.0).round]
    end.to_h
  end

  def get_data(level, ranges)
    data = ranges.map do |obj|
      obj[:attributes].map do |attribute|
        [attribute, obj[:ratings][level]]
      end
    end.flatten(1).to_h

    ATTRIBUTES.map do |attribute|
      if attribute.in?(["AWR"])
        [attribute, [[6,7],[5,7],[4,6],[3,6],[2,5],[1,5]][level]]
      elsif attribute.in?(["STA","TGH","INJ"])
        [attribute, [[3,7],[2,7],[2,6],[2,6],[2,5],[1,5]][level]]
      else
        [attribute, (data[attribute] || [1,7])]
      end
    end
  end

  def get_birthdate(year, age)
    day = (age == 20 ? Kernel.rand(100..365) : Kernel.rand(1..365))
    year = (year - (day <= 100 ? age : (age + 1)))
    Date.ordinal(year, day).strftime("%-m/%-d/%Y")
  end


  private

  AGES = [
    [0.9, 0.45, 0, 0], [1, 0.5, 0, 0], [1, 0.6, 0.1, 0], [1, 0.75, 0.25, 0], [1, 0.9, 0.5, 0.2], [1, 1, 0.9, 0.4]
  ].freeze

  ATTRIBUTES = [
    "SPD","ACC","AGI","STR","AWR","CAR","BCV","BKT","TRK","SFA","ELU","SPM",
    "JKM","CAT","CIT","SPC","SRR","MRR","DRR","REL","JUM","THP","SAC","MAC",
    "DAC","TOR","TUP","BSK","PLA","PBL","PBP","PBF","RBL","RBP","RBF","LBK",
    "IMP","PLR","TAK","HIT","BSG","FMV","PMV","PUR","MCV","ZCV","PRE","KRT",
    "KPW","KAC","STA","TGH","INJ"
  ].freeze
end
