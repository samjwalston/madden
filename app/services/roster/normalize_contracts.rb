class Roster::NormalizeContracts < ApplicationService
  def initialize(**parameters)
    @players = parameters[:players]
  end

  def call
    raise(ArgumentError.new("players is not an array")) if !@players.is_a?(Array)
    raise(ArgumentError.new("players is invalid")) if !valid_players?

    if !valid_contracts?
      @players = update_contracts
    end

    @players
  end


  private

  def valid_players?
    has_contracts = @players.map do |player|
      player.key?(:contract) && player[:contract].key?(:cap_hit) &&
        player[:contract][:cap_hit].is_a?(Integer) && player[:contract][:cap_hit] > 0
    end.uniq

    has_contracts.size == 1 && has_contracts.first == true
  end

  def valid_contracts?
    salary_cap = @players.map{|p| p[:contract][:cap_hit]}.sum
    salary_cap >= 12_000 && salary_cap <= 19_000
  end

  def update_contracts
    salary_cap = @players.map{|p| p[:contract][:cap_hit]}.sum

    if salary_cap < 12_000
      players = @players.sort{|a,b| b[:rating] <=> a[:rating]}
      multiplier = (1 + (((12_000 / salary_cap.to_d) - 1) * 2)).round(4)
      modify_contracts(players, salary_cap, multiplier)
    elsif salary_cap > 19_000
      players = @players.sort{|a,b| a[:rating] <=> b[:rating]}
      multiplier = ((19_000 / salary_cap.to_d) / 2).round(4)
      modify_contracts(players, salary_cap, multiplier)
    else
      @players
    end
  end

  def modify_contracts(players, salary_cap, multiplier, index = 0)
    while (index < players.size && (salary_cap < 12_000 || salary_cap > 19_000))
      player = players[index]

      if player[:contract].key?(:salary)
        old_cap_hit = player[:contract][:cap_hit]
        new_cap_hit = [4000, [45, (player[:contract][:cap_hit].to_d * multiplier).to_i].max].min
        bonus_cap = (new_cap_hit * 0.5.to_d).floor
        new_bonus = [(new_cap_hit - 45), (player[:contract][:bonus] > bonus_cap ? bonus_cap : player[:contract][:bonus])].min

        player[:contract] = {
          cap_hit: new_cap_hit,
          salary: (new_cap_hit - new_bonus),
          bonus: new_bonus
        }

        salary_cap += (new_cap_hit - old_cap_hit)
      end

      index += 1
    end

    players
  end
end
