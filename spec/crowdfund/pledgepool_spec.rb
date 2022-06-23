#require_relative "pledgepool"
require 'crowdfund/pledgepool'

module Crowdfund  
  describe Pledge do
    before do
      @pledge = Pledge.new(:Gold, 100)
    end

    it "has correct name attribute" do
      @pledge.name.should == :Gold
    end

    it "has a correct amount attribute" do
      @pledge.amount.should == 100
    end

  end

  describe PledgePool do

    it "returns a random pledge tier from the pledgepool" do
      pledge = PledgePool.random
      PledgePool::PLEDGES.should include(pledge)
    end

    it "has three pledge tiers" do
      PledgePool::PLEDGES.size.should == 3
    end

    it "includes Gold ($100)" do
      PledgePool::PLEDGES[0].should == Pledge.new(:Gold, 100)
    end

    it "includes Silver ($75)" do
      PledgePool::PLEDGES[1].should == Pledge.new(:Silver, 75)
    end

    it "includes Bronze ($50)" do
      PledgePool::PLEDGES[2].should == Pledge.new(:Bronze, 50)
    end

  end
end