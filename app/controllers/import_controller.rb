class ImportController < ApplicationController
  def teams
    inspect_data
  end

  def rosters
    inspect_data
  end

  def schedules
    inspect_data
  end


  private

  def inspect_data
    puts "==="
    puts request.format
    puts "==="

    head :no_content
  end
end
