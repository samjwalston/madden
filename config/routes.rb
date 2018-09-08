Rails.application.routes.draw do
  root to: 'home#index'

  scope module: :import, path: '/:platform/:league_id' do
    # /:platform/:franchise_id/leagueteams
    post :leagueteams, action: :teams, as: :team_import
    # /:platform/:franchise_id/team/:team_id/roster
    post '/team/:team_id/roster', action: :rosters, as: :roster_import
    # /:platform/:franchise_id/week/:week_type/:week_num/schedules
    post '/week/:week_type/:week_num/schedules', action: :schedules, as: :schedule_import
  end
end
