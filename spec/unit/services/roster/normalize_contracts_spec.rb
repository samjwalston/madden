require 'rails_helper'
require './spec/unit/factories/roster'

RSpec.describe Roster::NormalizeContracts do
  context "given an array of valid players" do
    before(:all) do
      @players = Roster::NormalizeContracts.new(players: RosterFactory.players).call
    end

    it "returns a valid array of players" do
      expect(@players).to be_a_kind_of(Array)
      expect(@players.size).to eq(52)
    end

    context "given an array of average players" do
      it "returns an array of valid players" do
        salary_cap = 0

        @players.each do |player|
          salary_cap += player[:contract][:cap_hit]

          expect(player[:contract][:cap_hit]).to be_between(45, 4000)
          expect(player[:contract][:salary]).to be_between(45, 2000)
          expect(player[:contract][:bonus]).to be_between(0, 2000)
        end

        expect(salary_cap).to be_between(12_000, 19_000)
      end
    end

    context "given an array of elite players" do
      it "returns an array of valid players" do
        players = Roster::NormalizeContracts.new(players: RosterFactory.players(:elite)).call
        salary_cap = 0

        players.each do |player|
          salary_cap += player[:contract][:cap_hit]

          expect(player[:contract][:cap_hit]).to be_between(45, 4000)
          expect(player[:contract][:salary]).to be_between(45, 2000)
          expect(player[:contract][:bonus]).to be_between(0, 2000)
        end

        expect(salary_cap).to be_between(12_000, 19_000)
      end
    end

    context "given an array of poor players" do
      it "returns an array of valid players" do
        players = Roster::NormalizeContracts.new(players: RosterFactory.players(:poor)).call
        salary_cap = 0

        players.each do |player|
          salary_cap += player[:contract][:cap_hit]

          expect(player[:contract][:cap_hit]).to be_between(45, 4000)
          expect(player[:contract][:salary]).to be_between(45, 2000)
          expect(player[:contract][:bonus]).to be_between(0, 2000)
        end

        expect(salary_cap).to be_between(12_000, 19_000)
      end
    end
  end

  context "given an array of invalid players" do
    it "raises an error" do
      expect{Roster::NormalizeContracts.new(players: [{}]).call}.to raise_error(ArgumentError, "players is invalid")
      expect{Roster::NormalizeContracts.new(players: [{contract: {}}]).call}.to raise_error(ArgumentError, "players is invalid")
      expect{Roster::NormalizeContracts.new(players: [{contract: {cap_hit: nil}}]).call}.to raise_error(ArgumentError, "players is invalid")
      expect{Roster::NormalizeContracts.new(players: [{contract: {cap_hit: 0.0}}]).call}.to raise_error(ArgumentError, "players is invalid")
      expect{Roster::NormalizeContracts.new(players: [{contract: {cap_hit: 0.to_d}}]).call}.to raise_error(ArgumentError, "players is invalid")
      expect{Roster::NormalizeContracts.new(players: [{contract: {cap_hit: "0"}}]).call}.to raise_error(ArgumentError, "players is invalid")
    end
  end

  context "given anything other than an array of players" do
    it "raises an error" do
      expect{Roster::NormalizeContracts.new.call}.to raise_error(ArgumentError, "players is not an array")
      expect{Roster::NormalizeContracts.new(players: nil).call}.to raise_error(ArgumentError, "players is not an array")
      expect{Roster::NormalizeContracts.new(players: "").call}.to raise_error(ArgumentError, "players is not an array")
      expect{Roster::NormalizeContracts.new(players: 1).call}.to raise_error(ArgumentError, "players is not an array")
      expect{Roster::NormalizeContracts.new(players: {k: "v"}).call}.to raise_error(ArgumentError, "players is not an array")
    end
  end
end
