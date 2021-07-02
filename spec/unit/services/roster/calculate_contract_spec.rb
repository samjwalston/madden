require 'rails_helper'
require './spec/unit/factories/roster'

RSpec.describe Roster::CalculateContract do
  context "given a valid player hash object" do
    before(:all) do
      @player = Roster::CalculateContract.new(player: {role: "QB", rating: 99}).call
    end

    it "returns a valid player hash object" do
      expect(@player).to be_a_kind_of(Hash)
      expect(@player).to have_key(:contract)
    end

    context "given a player on a rookie contract" do
      it "returns player with contract that was passed in" do
        player = Roster::CalculateContract.new(player: {is_rookie: 600}).call
        expect(player[:contract][:cap_hit]).to eq(600)
      end
    end

    context "given a player not on a rookie contract" do
      it "returns player with calculated contract" do
        players = RosterFactory.players

        qb = Roster::CalculateContract.new(player: {role: "QB", rating: 99}).call
        expect(qb[:contract][:cap_hit]).to eq(4000)
        expect(qb[:contract][:salary]).to eq(2000)
        expect(qb[:contract][:bonus]).to eq(2000)

        hb = Roster::CalculateContract.new(player: {role: "HB", rating: 95}).call
        expect(hb[:contract][:cap_hit]).to eq(1234)
        expect(hb[:contract][:salary]).to eq(617)
        expect(hb[:contract][:bonus]).to eq(617)

        wr = Roster::CalculateContract.new(player: {role: "WR", rating: 91}).call
        expect(wr[:contract][:cap_hit]).to eq(1921)
        expect(wr[:contract][:salary]).to eq(1153)
        expect(wr[:contract][:bonus]).to eq(768)

        te = Roster::CalculateContract.new(player: {role: "TE", rating: 87}).call
        expect(te[:contract][:cap_hit]).to eq(1003)
        expect(te[:contract][:salary]).to eq(702)
        expect(te[:contract][:bonus]).to eq(301)

        ot = Roster::CalculateContract.new(player: {role: "OT", rating: 83}).call
        expect(ot[:contract][:cap_hit]).to eq(1207)
        expect(ot[:contract][:salary]).to eq(966)
        expect(ot[:contract][:bonus]).to eq(241)

        iol = Roster::CalculateContract.new(player: {role: "IOL", rating: 79}).call
        expect(iol[:contract][:cap_hit]).to eq(766)
        expect(iol[:contract][:salary]).to eq(689)
        expect(iol[:contract][:bonus]).to eq(77)

        ed = Roster::CalculateContract.new(player: {role: "ED", rating: 75}).call
        expect(ed[:contract][:cap_hit]).to eq(662)
        expect(ed[:contract][:salary]).to eq(596)
        expect(ed[:contract][:bonus]).to eq(66)

        idl = Roster::CalculateContract.new(player: {role: "IDL", rating: 70}).call
        expect(idl[:contract][:cap_hit]).to eq(300)
        expect(idl[:contract][:salary]).to eq(270)
        expect(idl[:contract][:bonus]).to eq(30)

        lb = Roster::CalculateContract.new(player: {role: "LB", rating: 67}).call
        expect(lb[:contract][:cap_hit]).to eq(225)
        expect(lb[:contract][:salary]).to eq(225)
        expect(lb[:contract][:bonus]).to eq(0)

        cb = Roster::CalculateContract.new(player: {role: "CB", rating: 63}).call
        expect(cb[:contract][:cap_hit]).to eq(125)
        expect(cb[:contract][:salary]).to eq(125)
        expect(cb[:contract][:bonus]).to eq(0)

        s = Roster::CalculateContract.new(player: {role: "S", rating: 59}).call
        expect(s[:contract][:cap_hit]).to eq(45)
        expect(s[:contract][:salary]).to eq(45)
        expect(s[:contract][:bonus]).to eq(0)

        k = Roster::CalculateContract.new(player: {role: "K", rating: 55}).call
        expect(k[:contract][:cap_hit]).to eq(45)
        expect(k[:contract][:salary]).to eq(45)
        expect(k[:contract][:bonus]).to eq(0)
      end
    end
  end

  context "given an invalid player hash object" do
    it "raises an error" do
      expect{Roster::CalculateContract.new(player: {}).call}.to raise_error(ArgumentError, "player is invalid")
      expect{Roster::CalculateContract.new(player: {rating: 70}).call}.to raise_error(ArgumentError, "player is invalid")
      expect{Roster::CalculateContract.new(player: {role: nil, rating: 70}).call}.to raise_error(ArgumentError, "player is invalid")
      expect{Roster::CalculateContract.new(player: {role: "FAKE", rating: 70}).call}.to raise_error(ArgumentError, "player is invalid")
      expect{Roster::CalculateContract.new(player: {role: 2, rating: 70}).call}.to raise_error(ArgumentError, "player is invalid")
      expect{Roster::CalculateContract.new(player: {role: "QB"}).call}.to raise_error(ArgumentError, "player is invalid")
      expect{Roster::CalculateContract.new(player: {role: "QB", rating: 70.0}).call}.to raise_error(ArgumentError, "player is invalid")
      expect{Roster::CalculateContract.new(player: {role: "QB", rating: 70.to_d}).call}.to raise_error(ArgumentError, "player is invalid")
      expect{Roster::CalculateContract.new(player: {role: "QB", rating: "70"}).call}.to raise_error(ArgumentError, "player is invalid")
      expect{Roster::CalculateContract.new(player: {role: "QB", rating: 100}).call}.to raise_error(ArgumentError, "player is invalid")
      expect{Roster::CalculateContract.new(player: {role: "QB", rating: 10}).call}.to raise_error(ArgumentError, "player is invalid")
      expect{Roster::CalculateContract.new(player: {is_rookie: nil}).call}.to raise_error(ArgumentError, "player is invalid")
      expect{Roster::CalculateContract.new(player: {is_rookie: 0}).call}.to raise_error(ArgumentError, "player is invalid")
      expect{Roster::CalculateContract.new(player: {is_rookie: 0.0}).call}.to raise_error(ArgumentError, "player is invalid")
      expect{Roster::CalculateContract.new(player: {is_rookie: 0.to_d}).call}.to raise_error(ArgumentError, "player is invalid")
      expect{Roster::CalculateContract.new(player: {is_rookie: "0"}).call}.to raise_error(ArgumentError, "player is invalid")
    end
  end

  context "given anything other than a hash object" do
    it "raises an error" do
      expect{Roster::CalculateContract.new.call}.to raise_error(ArgumentError, "player is not a hash object")
      expect{Roster::CalculateContract.new(player: nil).call}.to raise_error(ArgumentError, "player is not a hash object")
      expect{Roster::CalculateContract.new(player: "").call}.to raise_error(ArgumentError, "player is not a hash object")
      expect{Roster::CalculateContract.new(player: 1).call}.to raise_error(ArgumentError, "player is not a hash object")
      expect{Roster::CalculateContract.new(player: []).call}.to raise_error(ArgumentError, "player is not a hash object")
    end
  end
end
