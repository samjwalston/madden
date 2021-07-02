class Roster::DistributePlayers < ApplicationService
  VALUES = [0.9, 0.7, 0.67, 0.64, 0.62, 0.6, 0.59, 0.58, 0.57, 0.56, 0.55, 0.54, 0.53, 0.52, 0.51, 0.5, 0.5, 0.49, 0.48, 0.47, 0.46, 0.45, 0.44, 0.43, 0.42, 0.41, 0.4, 0.38, 0.36, 0.33, 0.3, 0.1].freeze
  ROLES = {"QB"=>2, "HB"=>4, "WR"=>6, "TE"=>4, "OT"=>4, "IOL"=>6, "ED"=>4, "IDL"=>6, "LB"=>4, "CB"=>6, "S"=>4, "K"=>2}.freeze
  VALUE_MAX = 0.8.to_d.freeze
  VALUE_MIN = 0.2.to_d.freeze


  def initialize(**parameters)
    @teams = parameters[:teams]
    @values = get_values
    @roles = get_roles
  end

  def call
    raise(ArgumentError.new("'teams' is invalid")) if !valid_teams?

    while !valid_rosters?
      @teams = assign_players
    end

    @teams.map do |team|
      team[:value] = (team[:value].to_d / ROLES.values.sum).round(2).to_f
      team
    end
  end


  private

  def valid_teams?
    @teams.is_a?(Array) && @teams.map{|team| team[:id]}.compact.uniq.size == 32
  end

  def get_values
    VALUES.dup.map(&:to_d)
  end

  def get_roles
    ROLES.dup.map do |role, count|
      (1..count).map do |num|
        {name: role, depth: num}
      end
    end.flatten
  end

  def assign_players
    teams = reset_teams

    @roles.each_with_index do |role, round|
      teams.shuffle.each_with_index do |roster, index|
        roster[:value] += @values[index]
        roster[:players] << role.merge({index: (((role[:depth] - 1) * 32) + index)})
      end
    end

    teams
  end

  def reset_teams
    @teams.map do |team|
      team.merge({value: 0.to_d, players: []})
    end
  end

  def valid_rosters?(is_valid = true)
    @teams.each do |team|
      value = (team[:value].to_d / ROLES.values.sum).round(2)
      break if !(is_valid = !(value > VALUE_MAX || value < VALUE_MIN))
    end

    is_valid
  end
end
