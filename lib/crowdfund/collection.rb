require_relative 'project'
require_relative 'die'
require_relative 'collection_turn'
require 'csv'
module Crowdfund
    class Collection
        attr_reader :name, :collection
        def initialize(name)       #this method converts a Collection.new specified title to the correct format when created
            @name = name.upcase    #upcased all collection titles for now
            @collection = []
            puts "Collection '#{@name}' was created."
        end

        def add_project(project)
            @collection << project 
        end
        def show_pledges
            pledges = PledgePool::PLEDGES
            puts "\nThere are #{pledges.size} pledge tiers:"
            pledges.each do |p|
            puts "#{p.name} tier is a donation of $#{p.amount}."
            end
        end

        def print_stats
            puts "\n#{@name}"
            @sorted_list = @collection.sort { |a, b| b.amount <=> a.amount }
            @sorted_list.each do |p|
                p.describe
                puts "Total pledge tier donations for #{p.name}:"
                p.each_pledge_received do |pledge|
                puts "#{pledge.name}: $#{pledge.amount}"
            end
            puts "Other donations: $#{p.amount}"
            end

            met_goal, under_goal = @sorted_list.partition { |project| project.total_amount >= project.target_goal }
                unless met_goal.empty?
                    puts "\nProjects at/over goal:" 
                    met_goal.each do |project|
                    puts "#{project.name}: $#{project.total_amount}/#{project.target_goal}" #NOTE:  ALWAYS CALL TOTAL_AMOUNT (sum of all pledges + @amount)
                    end
                end
                unless under_goal.empty?
                    puts "\nProjects under goal:" 
                    under_goal.each do |project|
                    puts "#{project.name}: $#{project.total_amount}/#{project.target_goal}" #NOTE:  ALWAYS CALL TOTAL_AMOUNT (sum of all pledges + @amount)
                    end
                end

        end

        def run_projects(rounds=1) #play one round by default
            puts "\nThere are currently #{@collection.size} projects:" #no sorting called here at first
            @collection.each do |project|
                puts "#{@collection.index(project) + 1}) #{project.name}"
            end

            show_pledges

            1.upto(rounds) do |round|
                puts "\nRound #{round}:"

                @collection.each do |p|
                    puts "Start: #{p}"
                    CollectionTurn.take_turn(p)
                    puts "End: #{p}"
                end

            # after all rounds, this describes each project's funding (similar to print stats method for the playlist project):
            end
        end
        def load_projects(from_file)
            CSV.foreach(from_file, 'r:bom|utf-8') do |row| #this conditional gets tricky! 
                unless row[1].to_i == 0  ||  row[2].to_i == 0 #unless one of the rows has a nil value...
                    project = Project.new(row[0], row[1].to_i, row[2].to_i) #.. then input all values regularly.
                else
                    if row[1].to_i == 0 # if amount (second column) is nil >> 0 in csv,
                        project = Project.new(row[0], 0, row[2].to_i) # the default gets set to 0. THIS is where default gets assigned.
                    end
                    if row[2].to_i == 0 # if target_goal (third column) is nil >> 0 in csv,
                        project = Project.new(row[0], row[1].to_i, 10000) # the default target gets set to 10000. THIS is where default gets assigned.
                    end
                end
            add_project(project)
            end
        end
        def save_output(to_file="crowdfund_output.txt")
            File.open(to_file, "w") do |file|
            file.puts Time.new.strftime("File updated on %m/%d/%Y at %I:%M %p")
            file.puts "#{@name}"
            file.puts "\nCrowdfund Output:"

            @collection.each do |project|     
                if project.total_amount > project.target_goal
                    file.puts "\nProject #{project.name}: $#{project.total_amount}/#{project.target_goal} (over goal)"
                elsif project.total_amount == project.target_goal
                    file.puts "\nProject #{project.name}: $#{project.total_amount}/#{project.target_goal} (at goal)"
                else
                    file.puts "\nProject #{project.name}: $#{project.total_amount}/#{project.target_goal} (under goal)" 
                end

                file.puts "Total pledge tier donations for #{project.name}:"
                project.each_pledge_received do |pledge|
                file.puts "#{pledge.name}: $#{pledge.amount}"
                end
                file.puts "Other donations: $#{project.amount}"
                end

                met_goal, under_goal = @collection.partition { |project| project.total_amount >= project.target_goal }
                unless met_goal.empty?
                file.puts "\nProjects at/over goal:" 
                met_goal.each do |project|
                file.puts "#{project.name}: $#{project.total_amount}/#{project.target_goal}" #NOTE:  ALWAYS CALL TOTAL_AMOUNT (sum of all pledges + @amount)
                end
            end
            unless under_goal.empty?
                file.puts "\nProjects under goal:" 
                under_goal.each do |project|
                file.puts "#{project.name}: $#{project.total_amount}/#{project.target_goal}" #NOTE:  ALWAYS CALL TOTAL_AMOUNT (sum of all pledges + @amount)
                end
            end
            end 
        
    
        end
    end
end