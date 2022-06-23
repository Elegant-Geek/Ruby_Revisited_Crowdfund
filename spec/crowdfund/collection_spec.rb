require_relative "collection"
require_relative "die"
module Crowdfund
    describe Collection do

    before do
        @collection = Collection.new("test collection")
    end

    context "single project collection" do
        before do
            @collection = Collection.new("Jamie's collection of projects")
        end

        before do
            @initial_amount = -500
            @project = Project.new('ABC', @initial_amount, -3000)
            @initial_amount = @project.amount #this line had to be added to update the @inital amount
            #variable in the test file so that it is updated to reflect the initialization of the "amount" attribute
            #of the project (which changes negative values to their absolute value versions!)
            @collection.add_project(@project)
            @round_amount = 3
        end

        it "FUNDS on a high number (5-6)" do
            Die.any_instance.stub(:roll).and_return(5)
            @collection.run_projects(@round_amount)
            expect(@project.amount).to eq(@initial_amount + (15 * (@round_amount)))
        end

        it "no change on medium number (3-4)" do
            Die.any_instance.stub(:roll).and_return(3)
            @collection.run_projects(@round_amount)
            expect(@project.amount).to eq(@initial_amount)
        end

        it "DEFUNDS on a low number (1-2)" do
            Die.any_instance.stub(:roll).and_return(1)
            @collection.run_projects(@round_amount)
            expect(@project.amount).to eq(@initial_amount - (10 * (@round_amount)))
        end
    end

    it "assigns a pledge tier and amount to tally during a project's turn" do
        collection = Collection.new("Test List")
        project = Project.new("ABC", 100, 200)
    
        collection.add_project(project)
    
        collection.run_projects(1) #runs 1 round
    
        project.amount.should_not be_zero
    
        # or use alternate expectation syntax:
        # expect(player.points).not_to be_zero
    end

    context "default values replacing nils (with default project file)" do
        before do 
            @my_collection = Collection.new("Test collection")
            @my_collection.load_projects("EXAMPLE_PROJECTS.csv") #plays an entered file OR the default (WALL.csv)
        end

        it "replaces nil amount values with default value of amount=0" do
            expect(@my_collection.collection[2].amount).to eq(0) # "XYZ,,300" gets filled in with "XYZ,0,300" 
        end
        it "replaces nil target_goal values with default value of target_goal=10000" do
            expect(@my_collection.collection[1].target_goal).to eq(10000) # "LMN,800," gets filled in with "LMN,800,1000"
        end
    end

    end
end