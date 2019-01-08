class Export
  require 'csv'


  def call
    headers = []
    data = {}

    CSV.foreach(Rails.root.join("attribute_weights.csv")) do |row|
      if headers.empty?
        headers = row[2..-3]
      else
        position = row[0].downcase
        archetype = row[1].parameterize.underscore

        if data[position].nil?
          data[position] = {}
        end

        data[position][archetype] = headers.zip(row[2..-3].map(&:to_i)).to_h.keep_if{|k,v| v > 0}
      end
    end

    data
  end
end
