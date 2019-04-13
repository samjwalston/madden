class Import::Schedule < ApplicationJob
  def perform(data)
    schedules = data["gameScheduleInfoList"].map do |schedule|
      format_data(schedule, {
        league_id: data["league_id"]
      })
    end

    Schedule.import(schedules, on_duplicate_key_update: :all)
  end


  private

  def format_data(attributes, parameters, details = {})
    attributes.merge(parameters).each do |key, value|
      key = key.to_s.underscore

      if Schedule.column_names.include?(key)
        details[key.to_sym] = value
      end
    end

    details[:id] = [parameters[:league_id], details[:schedule_id]].join(":")

    Schedule.new(details)
  end
end
