require 'rubygems'
require 'rspec'
require 'salary_averager'

describe SalaryAverager do
  before(:each) do
    @averager = SalaryAverager.new("spec/fake_data.csv") 
  end

  describe "#freelancer_salaries" do
    it "returns all salaries for people who are freelancers" do
      @averager.freelancer_salaries.should == [110000.0, 120000.0]
    end
  end

  describe "#non_freelancer_salaries" do
    it "returns all salaries for people who are not freelancers" do
      @averager.non_freelancer_salaries.should == [100000.0, 130000.0]
    end
  end

  describe "#manager_salaries" do
    it "returns all salaries for people who manage other devs" do
      @averager.manager_salaries.should == [100000.0, 120000.0, 130000.0]
    end
  end

  describe "#non_manager_salaries" do
    it "returns all salaries for people who do not manage other devs" do
      @averager.non_manager_salaries.should == [110000.0]
    end
  end
end

