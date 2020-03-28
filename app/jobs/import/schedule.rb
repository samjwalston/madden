class Import::Schedule < ApplicationJob
  def perform(data)
    schedules = data["gameScheduleInfoList"].map do |schedule|
      format_data(schedule)
    end

    Schedule.import(schedules, on_duplicate_key_update: :all)
  end


  private

  def format_data(attributes)
    details = {id: attributes["scheduleId"]}

    attributes.each do |key, value|
      key = key.to_s.underscore

      if Schedule.column_names.include?(key)
        details[key.to_sym] = value
      end
    end

    Schedule.new(details)
  end
end
