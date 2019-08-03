class ImportController < ApplicationController
  skip_before_action :verify_authenticity_token


  def teams
    inspect_data
    # Import::Team.perform_later(safe_params)
    # head :ok
  end

  def standings
    inspect_data
  end

  def rosters
    inspect_data
    # Import::Roster.perform_later(safe_params)
    # head :ok
  end

  def schedules
    inspect_data
    # Import::Schedule.perform_later(safe_params)
    # head :ok
  end


  private

  def inspect_data
    puts "==="
    puts safe_params.inspect
    puts "==="

    head :ok
  end

  def safe_params
    params.except(:message, :success, :import).to_unsafe_hash
  end
end
