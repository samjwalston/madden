class ImportController < ApplicationController
  def teams
    inspect_data
    head :no_content
  end

  def rosters
    inspect_data
    head :no_content
  end

  def schedules
    inspect_data
    head :no_content
  end


  private

  def inspect_data
    puts "Hello There"
  rescue
    puts "==="
    puts request.format
    puts "==="
  end
end
