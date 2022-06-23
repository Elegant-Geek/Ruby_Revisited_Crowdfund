Pledge = Struct.new(:name, :amount) #bigger number means more influence (I use them as multiplier values)
module Crowdfund
    module PledgePool

        PLEDGES = [
            Pledge.new(:Gold, 100),
            Pledge.new(:Silver, 75),
            Pledge.new(:Bronze, 50),
        ]

        def self.random
            PLEDGES.sample
        end
    end

    if __FILE__ == $0
        p PledgePool::PLEDGES.map(&:name)
        tier = PledgePool.random
        puts "#{tier.name} tier is a donation of $#{tier.amount}."
    end
end