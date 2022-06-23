require_relative 'collection'
require_relative 'die'
require_relative 'pledgepool'
module Crowdfund
    class Project
        attr_accessor :name, :amount #you can now write to amount for project to update it
        attr_reader :target_goal

        def initialize(name, amount=0, target_goal=10000)
            @name = name
            @amount = amount.abs() #no negative initial amount
            @target_goal = target_goal.abs() #no negative target value
            puts "New project '#{@name}' ($#{@amount}) is initialized. Target goal is #{@target_goal}."
            @pledges_received = Hash.new(0)
        end
        def pledge_received(pledge)
            @pledges_received[pledge.name] += pledge.amount #was missing the "s" on @pledges_received which is for the hash
            puts "#{@name} received a #{pledge.name} pledge worth $#{pledge.amount}."
            puts "#{@name}'s pledge amounts: #{@pledges_received}"
        end
        def total_amount
            @pledges_received.values.reduce(0, :+) + @amount
        end

        def fund(value=0)
            @amount += value
            puts "'#{@name}' received $#{value} in funding!"
            #puts "'#{@name}' now has $#{total_amount} in funding." #NOTE:  ALWAYS CALL TOTAL_AMOUNT (sum of all pledges + @amount)
        end
        def defund(value=0)
            @amount -= value
            puts "'#{@name}' has lost $#{value} in funding!"
            #puts "'#{@name}' now has $#{total_amount} in funding." #NOTE:  ALWAYS CALL TOTAL_AMOUNT (sum of all pledges + @amount)
        end

        def empty?
            total_amount <= 0
        end

        def target_goal_met?
            total_amount >= @target_goal
        end

        def status
            "(No funds!)" if empty?
        end

        def to_s #defines what happens when you use puts on an object of class "Song"
            if empty?
            "#{@name} ($#{total_amount}) #{status}"
            else
            "#{@name} ($#{total_amount})"
            end
        end

        def describe
            @current_time = Time.new.strftime("%-I:%M %p %-m/%-d/%-y")
                if total_amount > @target_goal #NOTE:  ALWAYS CALL TOTAL_AMOUNT (sum of all pledges + @amount)
                puts "\nProject #{@name}: $#{total_amount}/#{@target_goal} (over goal) as of #{@current_time}."
                elsif total_amount < @target_goal
                    puts "\nProject #{@name}: $#{total_amount}/#{@target_goal} (under goal) as of #{@current_time}."
                else
                    puts "\nProject #{@name}: $#{total_amount}/#{@target_goal} (at goal) as of #{@current_time}."
            end
        end

        def each_pledge_received
            @pledges_received.each do |name, amount| # (@pledges_received is the hash)
            yield Pledge.new(name, amount)
            end
        end

        #the default for the amount of funding is 100
        #therefore, $100 gets printed out for the "describe" method.

    end
end
