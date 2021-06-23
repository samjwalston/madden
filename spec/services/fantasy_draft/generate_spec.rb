require 'rails_helper'

RSpec.describe FantasyDraft::Generate do
  before(:all) do
    @teams = (1..described_class::VALUES.size).to_a.map do |num|
      {id: num, name: Faker::Sports::Football.team, value: 0.to_d, players: []}
    end
  end

  context "given an array of all teams" do
    before(:all) do
      @rosters = FantasyDraft::Generate.new(teams: @teams).call
    end

    it "returns teams array" do
      expect(@rosters).to be_a_kind_of(Array)
      expect(@rosters.size).to eq(described_class::VALUES.size)
    end

    it "returns teams with full rosters" do
      @rosters.each do |roster|
        expect(roster[:players].size).to eq(described_class::ROLES.values.sum)
      end
    end

    it "returns teams with valid rosters" do
      @rosters.each do |roster|
        expect(roster[:value]).to be_between(described_class::VALUE_MIN, described_class::VALUE_MAX)
      end
    end
  end

  context "given an array of not all teams" do
    it "raises an error" do
      expect{FantasyDraft::Generate.new(teams: []).call}.to raise_error(ArgumentError, "teams list is incomplete")
      expect{FantasyDraft::Generate.new(teams: @teams[0..10]).call}.to raise_error(ArgumentError, "teams list is incomplete")
      expect{FantasyDraft::Generate.new(teams: @teams[0..20]).call}.to raise_error(ArgumentError, "teams list is incomplete")
    end
  end

  context "given anything other than an array" do
    it "raises an error" do
      expect{FantasyDraft::Generate.new.call}.to raise_error(ArgumentError, "teams is not an array")
      expect{FantasyDraft::Generate.new(teams: "").call}.to raise_error(ArgumentError, "teams is not an array")
      expect{FantasyDraft::Generate.new(teams: 1).call}.to raise_error(ArgumentError, "teams is not an array")
      expect{FantasyDraft::Generate.new(teams: {key: "value"}).call}.to raise_error(ArgumentError, "teams is not an array")
    end
  end
end
