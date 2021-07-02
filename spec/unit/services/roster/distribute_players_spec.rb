require 'rails_helper'
require './spec/unit/factories/roster'

RSpec.describe Roster::DistributePlayers do
  before(:all) do
    @teams = RosterFactory.teams
  end

  context "given an array of valid teams" do
    before(:all) do
      @rosters = Roster::DistributePlayers.new(teams: @teams).call
    end

    it "returns teams with valid rosters" do
      expect(@rosters).to be_a_kind_of(Array)
      expect(@rosters.size).to eq(32)

      @rosters.each do |roster|
        expect(roster[:players]).to be_a_kind_of(Array)
        expect(roster[:players].size).to eq(52)

        expect(roster[:value]).to be_a_kind_of(Numeric)
        expect(roster[:value]).to be_between(0.2, 0.8)
      end
    end
  end

  context "given an array of invalid teams" do
    it "raises an error" do
      expect{Roster::DistributePlayers.new(teams: []).call}.to raise_error(ArgumentError, "'teams' is invalid")
      expect{Roster::DistributePlayers.new(teams: @teams[0..10]).call}.to raise_error(ArgumentError, "'teams' is invalid")
      expect{Roster::DistributePlayers.new(teams: @teams[0..20]).call}.to raise_error(ArgumentError, "'teams' is invalid")
      expect{Roster::DistributePlayers.new(teams: [{}]).call}.to raise_error(ArgumentError, "'teams' is invalid")
      expect{Roster::DistributePlayers.new(teams: (1..32).collect{|n| {id: 1}}).call}.to raise_error(ArgumentError, "'teams' is invalid")
    end
  end

  context "given anything other than an array" do
    it "raises an error" do
      expect{Roster::DistributePlayers.new.call}.to raise_error(ArgumentError, "'teams' is invalid")
      expect{Roster::DistributePlayers.new(teams: "").call}.to raise_error(ArgumentError, "'teams' is invalid")
      expect{Roster::DistributePlayers.new(teams: 1).call}.to raise_error(ArgumentError, "'teams' is invalid")
      expect{Roster::DistributePlayers.new(teams: {k: "v"}).call}.to raise_error(ArgumentError, "'teams' is invalid")
    end
  end
end
