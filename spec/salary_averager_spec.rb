require 'rubygems'
require 'rspec'
require 'salary_averager'

describe SalaryAverager do
  before(:each) do
    @averager = SalaryAverager.new("spec/fake_data.csv") 
  end

  describe "#average_salary" do
    it "returns the average salary for all entries" do
      @averager.average_salary.should == 110000.0
    end
  end

  describe "salaries" do
    it "returns an array of salary floats" do
      @averager.salaries.should == [100000.0, 120000.0]
    end
  end
end

