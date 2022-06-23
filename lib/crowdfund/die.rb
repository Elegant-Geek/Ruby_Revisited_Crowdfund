module Crowdfund #you can delete one of these modules (based on..) once/how you split up your projects
        class Die 
        attr_reader :number

        def roll
            @number = rand(1..6)
        end

        def initialize
            roll #the new die object now initializes as soon as "roll" is called anywhere.
        end
    end
end
module Songfile #you can delete one of these once you split up your projects
    class Die 
        attr_reader :number

        def roll
            @number = rand(1..6)
        end

        def initialize
            roll #the new die object now initializes as soon as "roll" is called anywhere.
        end
    end
end