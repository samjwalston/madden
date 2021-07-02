class Roster::CalculateContract < ApplicationService
  def initialize(**parameters)
    @player = parameters[:player]
  end

  def call
    raise(ArgumentError.new("player is not a hash object")) if !@player.is_a?(Hash)
    raise(ArgumentError.new("player is invalid")) if !valid_player?

    @player[:contract] = if @player.key?(:is_rookie)
      calculate_rookie_contract
    else
      calculate_calculate
    end

    @player
  end


  private

  def valid_player?
    (
      (!@player.key?(:is_rookie) &&
        (@player.key?(:role) && @player[:role].in?(["QB","HB","WR","TE","OT","IOL","ED","IDL","LB","CB","S","K"])) &&
        (@player.key?(:rating) && @player[:rating].is_a?(Integer) && @player[:rating] <= 99 && @player[:rating] >= 12)
      ) || (@player[:is_rookie].is_a?(Integer) && @player[:is_rookie] > 0)
    )
  end

  def calculate_rookie_contract
    {cap_hit: @player.delete(:is_rookie)}
  end

  def calculate_calculate
    values = {
      "QB"=>{max: 4000, min: 1000},
      "HB"=>{max: 1400, min: 200},
      "WR"=>{max: 2500, min: 400},
      "TE"=>{max: 1500, min: 300},
      "OT"=>{max: 2200, min: 400},
      "IOL"=>{max: 1800, min: 300},
      "ED"=>{max: 2400, min: 300},
      "IDL"=>{max: 2000, min: 300},
      "LB"=>{max: 1800, min: 300},
      "CB"=>{max: 2100, min: 300},
      "S"=>{max: 1500, min: 300},
      "K"=>{max: 700, min: 100},
    }[@player[:role]]

    cap_hit = if @player[:rating] >= 70
      (((values[:max].to_d - values[:min].to_d) / 29.to_d) * (@player[:rating] - 70)).round + values[:min].to_d
    elsif @player[:rating] >= 60
      (((values[:min].to_d - 50.to_d) / 10.to_d) * (@player[:rating] - 60)).round + 50.to_d
    else
      45.to_d
    end

    if @player[:rating] >= 95
      salary = (cap_hit * 0.5.to_d).round.to_i
      {cap_hit: cap_hit.to_i, salary: salary, bonus: (cap_hit.to_i - salary)}
    elsif @player[:rating] >= 90
      salary = (cap_hit * 0.6.to_d).round.to_i
      {cap_hit: cap_hit.to_i, salary: salary, bonus: (cap_hit.to_i - salary)}
    elsif @player[:rating] >= 85
      salary = (cap_hit * 0.7.to_d).round.to_i
      {cap_hit: cap_hit.to_i, salary: salary, bonus: (cap_hit.to_i - salary)}
    elsif @player[:rating] >= 80
      salary = (cap_hit * 0.8.to_d).round.to_i
      {cap_hit: cap_hit.to_i, salary: salary, bonus: (cap_hit.to_i - salary)}
    elsif @player[:rating] >= 70
      salary = (cap_hit * 0.9.to_d).round.to_i
      {cap_hit: cap_hit.to_i, salary: salary, bonus: (cap_hit.to_i - salary)}
    else
      {cap_hit: cap_hit.to_i, salary: cap_hit.to_i, bonus: 0}
    end
  end
end
