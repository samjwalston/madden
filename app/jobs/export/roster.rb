class Export::Roster < ApplicationJob
  require 'csv'


  before_perform do
    @rosters = get_rosters
  end


  def perform(filepath)
    CSV.foreach(Rails.root.join("vendor/roster.csv"), headers: true, header_converters: :symbol) do |row|
      player = nil

      @rosters.each do |plyr|
        if plyr[:name] == [row[:pfna], row[:plna]].compact.join(" ") && plyr[:age].to_i == row[:page].to_i
          player = plyr
          break
        end
      end

      if player.nil?
        row[:tgid] = 1009
        row[:pcon], row[:pcyl], row[:pcsa], row[:ptsa], row[:psbo] = 0, 0, 0, 0, 0
        row[:psa0], row[:psa1], row[:psa2], row[:psa3], row[:psa4], row[:psa5], row[:psa6] = 0, 0, 0, 0, 0, 0, 0
        row[:psb0], row[:psb1], row[:psb2], row[:psb3], row[:psb4], row[:psb5], row[:psb6] = 0, 0, 0, 0, 0, 0, 0
      else
        row[:tgid] = player[:team_id]

        if row[:pyrp].to_i >= 4 # :NOTE: Only calculate contracts for players not on 'Rookie Deal'
          row[:ptsa] = (row[:pcon].to_i * player[:contract][:cap_hit])   # total cap hit
          row[:psbo] = (row[:pcon].to_i * player[:contract][:bonus])     # total bonus
          row[:pcsa] = player[:contract][:cap_hit]                       # current cap hit

          row[:psa0] = player[:contract][:salary] if row[:pcon].to_i >= 1
          row[:psa1] = player[:contract][:salary] if row[:pcon].to_i >= 2
          row[:psa2] = player[:contract][:salary] if row[:pcon].to_i >= 3
          row[:psa3] = player[:contract][:salary] if row[:pcon].to_i >= 4
          row[:psa4] = player[:contract][:salary] if row[:pcon].to_i >= 5
          row[:psa5] = player[:contract][:salary] if row[:pcon].to_i >= 6
          row[:psa6] = player[:contract][:salary] if row[:pcon].to_i >= 7

          row[:psb0] = player[:contract][:bonus] if row[:pcon].to_i >= 1
          row[:psb1] = player[:contract][:bonus] if row[:pcon].to_i >= 2
          row[:psb2] = player[:contract][:bonus] if row[:pcon].to_i >= 3
          row[:psb3] = player[:contract][:bonus] if row[:pcon].to_i >= 4
          row[:psb4] = player[:contract][:bonus] if row[:pcon].to_i >= 5
          row[:psb5] = player[:contract][:bonus] if row[:pcon].to_i >= 6
          row[:psb6] = player[:contract][:bonus] if row[:pcon].to_i >= 7
        end
      end

      data << row.to_h.values
    end

    true
  end


  private

  def get_rosters
    teams = Team.select(:id).order(:id).map{|j| {id: j.id}}
    rosters = Roster::DistributePlayers.new(teams: teams).call
    players = get_players

    rosters.map do |roster|
      list = roster[:players].map do |role|
        player = players[role[:name]][role[:index]]
        contract = if player.years_pro < 4 && !player.contract.nil?
          Roster::CalculateContract.new(player: {is_rookie: (player.contract.cap_hit / 1000).to_i}).call[:contract]
        else
          Roster::CalculateContract.new(player: {role: role[:name], rating: player.rating}).call[:contract]
        end

        {
          team_id: roster[:id],
          name: player.name,
          age: player.age,
          contract: contract,
        }
      end

      Roster::NormalizeContracts.new(players: list).call
    end.flatten
  end

  def get_players
    {
      "QB" => Player.where(role: "QB").order(value: :desc, age: :asc, name: :asc).limit(64).to_a,
      "HB" => Player.where(role: "HB").order(value: :desc, age: :asc, name: :asc).limit(128).to_a,
      "WR" => Player.where(role: "WR").order(value: :desc, age: :asc, name: :asc).limit(192).to_a,
      "TE" => Player.where(role: "TE").order(value: :desc, age: :asc, name: :asc).limit(128).to_a,
      "OT" => Player.where(role: "OT").order(value: :desc, age: :asc, name: :asc).limit(128).to_a,
      "IOL" => Player.where(role: "IOL").order(value: :desc, age: :asc, name: :asc).limit(192).to_a,
      "ED" => Player.where(role: "ED").order(value: :desc, age: :asc, name: :asc).limit(128).to_a,
      "IDL" => Player.where(role: "IDL").order(value: :desc, age: :asc, name: :asc).limit(192).to_a,
      "LB" => Player.where(role: "LB").order(value: :desc, age: :asc, name: :asc).limit(128).to_a,
      "CB" => Player.where(role: "CB").order(value: :desc, age: :asc, name: :asc).limit(192).to_a,
      "S" => Player.where(role: "S").order(value: :desc, age: :asc, name: :asc).limit(128).to_a,
      "K" => Player.where(role: "K").order(rating: :desc, age: :asc, name: :asc).limit(64).to_a
    }
  end
end
