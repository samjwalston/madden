class ImportController < ApplicationController
  skip_before_action :verify_authenticity_token


  def teams
    inspect_data
  end

  def standings
    inspect_data
  end

  def rosters
    Import::Roster.perform_later(safe_params)
  end

  def schedules
    inspect_data
  end


  private

  def inspect_data
    puts "==="
    puts params.inspect
    puts "==="

    head :no_content
  end

  def safe_params
    params.except(:message, :success, :import).to_unsafe_hash
  end
end
