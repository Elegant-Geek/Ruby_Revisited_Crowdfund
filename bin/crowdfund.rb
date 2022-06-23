#crowdfund (File created 8:43PM on 5/8/22)
#end of day one is 8:24pm-10:47pm 5/8/22
#day two is 5:45pm - .... 9pm 5/24/22
#day three is 9:55pm - ....  11:15pm 6/8/22 (oof)
#day four is 7:30pm - 8:30pm, resumed at 9:40pm - 1am  6/14/22 
#day five is 12:45pm - 1:30pm before work 6/15/22 
#day six is 12am - 7:05pm 7 hours straight 6/18/22 
#day seven is 4:30pm - 8:15pm and 10pm - 12:30am 6/19/22 
#day eight is 8:55pm - 11:45pm 6/20/22 
#day nine is 11:47pm - 5:34AM!! 6/22/22 (night)
#day ten is 8:08pm - 12:24am and 12:50am - 6/22/22 (day)

require_relative 'collection' # calls the collection class file 
require_relative 'project' # calls the project class file 
require_relative 'die'

my_collection = Crowdfund::Collection.new("Jamie's collection of projects")
my_collection.load_projects(ARGV.shift || "EXAMPLE_PROJECTS.csv") #plays an entered file OR the default (WALL.cs)

# [project1, project2, project3].each do |project|
#     my_collection.add_project(project)
# end

loop do
    puts "\nHow many rounds? ('quit' to exit)"
    ans = gets.chomp.downcase

    case ans
    when /^\d+$/
        if ans.to_i > 20
            puts "ERROR: Maximum number of rounds allowed: 20." # I will set a limit to 20 rounds
        else
        my_collection.run_projects(ans.to_i) # converts to integer
        end
    when 'quit', 'exit', 'q', 'e', 'ex'
        my_collection.print_stats
        break
    else
        puts "Please enter a number or 'quit'"
    end
end

my_collection.save_output #this goes after the loop


