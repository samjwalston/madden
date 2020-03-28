class StartNewSeason < ApplicationService
  def call
    Schedule.delete_all
    Player.delete_all
    PlayerArchetype.delete_all

    nil
  end
end
