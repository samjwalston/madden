class ImportController < ApplicationController
  skip_before_action :verify_authenticity_token


  def teams
    inspect_data
  end

  def standings
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
    puts response['Content-Encoding']
    puts request.format
    puts "==="

    head :no_content
  end
end
