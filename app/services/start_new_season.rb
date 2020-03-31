class StartNewSeason < ApplicationService
  def call
    Team.delete_all
    Schedule.delete_all
    Player.delete_all
    PlayerArchetype.delete_all

    nil
  end
end
