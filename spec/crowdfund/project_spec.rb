# ***** SONG TEST FILE *******
#require_relative 'project' # calls the project class file 
require 'crowdfund/project'
#require_relative 'pledgepool' # calls the project class file 
require 'crowdfund/pledgepool'
module Crowdfund
    describe Project do

        context "song with a NEGATIVE funding and target goal" do
            before do
                @project = Project.new("CVS", -10, -1000) # a user types in a negative rank (not ok)
            end

            it "automatically gets a negative rank # assigned to a positive rank #" do
                expect(@project.amount).to eq(10) #rather than -10
                expect(@project.target_goal).to eq(1000) #rather than -1000
            end
        end

        context "project description conditionals" do
            before do
                @initial_amount = 10
                @target_goal = 100
                @project = Project.new("CVS", @initial_amount, @target_goal)
                @time = Time.new.strftime("%-I:%M %p %-m/%-d/%-y")
            end
            it "correctly displays under goal" do
                expect do
                    @project.describe
                end.to output("\nProject CVS: $10/100 (under goal) as of #{@time}.\n").to_stdout
            end
            it "correctly displays over goal" do
                @project.amount = 200
                expect do
                    @project.describe
                end.to output("\nProject CVS: $200/100 (over goal) as of #{@time}.\n").to_stdout
            end
            it "correctly displays at goal" do
                @project.amount = 100
                expect do
                    @project.describe
                end.to output("\nProject CVS: $100/100 (at goal) as of #{@time}.\n").to_stdout
            end
        end

        context "project w/o amount or target goal defined" do
            before do
                @project = Project.new("CVS") # a user types in a negative rank (not ok)
            end

            it "has default amount of 0, and default target goal of 10000" do
                expect(@project.amount).to eq(0) 
                expect(@project.target_goal).to eq(10000) #rather than -1000
            end
        end

        before do
            @initial_amount = 10
            @project = Project.new("CVS", @initial_amount, 1000)
        end

        it "has a correct initial value" do
            expect(@project.amount).to eq(@initial_amount) #better, new syntax
        end

        it "has correct display with 'to_s' (Song)" do
            expect(@project.to_s).to eq("CVS ($#{@initial_amount})")
        end

        it "has correct amount after fund(100)" do
            @project.fund(100)
            expect(@project.amount).to eq(@initial_amount + 100) 
        end

        it "has correct amount after defund(100)" do
            @project.defund(100)
            expect(@project.amount).to eq(@initial_amount - 100)
        end

        it "has correct default of 0 for 'fund' method" do
            @project.fund
            expect(@project.amount).to eq(@initial_amount)
        end

        it "has correct default of 0 for 'defund' method" do
            @project.defund
            expect(@project.amount).to eq(@initial_amount)
        end

        it "computes the sum of all pledge donations" do
            @project.total_amount.should == 0 + @initial_amount
        
            @project.pledge_received(Pledge.new(:gold, 100))
        
            @project.total_amount.should == 100 + @initial_amount 
        
            @project.pledge_received(Pledge.new(:silver, 75))
        
            @project.total_amount.should == 175 + @initial_amount # 100 + 75 @initial amount (10 for now)
        
            @project.pledge_received(Pledge.new(:bronze, 50))
        
            @project.total_amount.should == 225 + @initial_amount # 175 + 50 + @initial amount (10 for now)
        end

        it "yields each pledge donation and its total contribution" do
            @project.pledge_received(Pledge.new(:bronze, 50))
            @project.pledge_received(Pledge.new(:bronze, 50))
            @project.pledge_received(Pledge.new(:silver, 75))
            @project.pledge_received(Pledge.new(:silver, 75))
            @project.pledge_received(Pledge.new(:silver, 75))
            @project.pledge_received(Pledge.new(:silver, 75))
            @project.pledge_received(Pledge.new(:gold, 100))
            @project.pledge_received(Pledge.new(:gold, 100))
        
            yielded = []
            @project.each_pledge_received do |pledge|
            yielded << pledge
            end
        
            yielded.should == [
            Pledge.new(:bronze, 100),
            Pledge.new(:silver, 300),
            Pledge.new(:gold, 200)
        ]
        end

    end
end