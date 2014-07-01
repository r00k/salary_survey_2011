require 'rubygems'
require 'rspec'
require 'salary_averager'

describe SalaryAverager do
  let(:averager) { SalaryAverager.new("spec/fake_data2013.csv") }

  describe "#freelancer_salaries" do
    it "returns all salaries for people who are freelancers" do
      expect(averager.freelancer_salaries).to eq([110000, 120000])
    end
  end

  describe "#non_freelancer_salaries" do
    it "returns all salaries for people who are not freelancers" do
      expect(averager.non_freelancer_salaries).to eq([100000, 130000])
    end
  end

  describe "#manager_salaries" do
    it "returns all salaries for people who manage other devs" do
      expect(averager.manager_salaries).to eq([100000, 120000, 130000])
    end
  end

  describe "#non_manager_salaries" do
    it "returns all salaries for people who do not manage other devs" do
      expect(averager.non_manager_salaries).to eq([110000])
    end
  end

  describe "#skill_ratings" do
    it "returns the skill ratings for everyone" do
      expect(averager.skill_ratings).to eq([6,6,7,8])
    end
  end

  it "errors on a spreadsheet without the right headers" do
    expect {
      SalaryAverager.new("spec/numbers_only.csv")
    }.to raise_error
  end

end

describe "SalaryAverager::Averager" do
  it "averages correctly" do
    expect(SalaryAverager::Averager.new([2,4,12]).average).to eq(6)
  end

  it "calculates median correctly on odd-length arrays" do
    expect(SalaryAverager::Averager.new([2,4,12]).median).to eq(4)
  end

  it "calculates median correctly on even-length arrays" do
    expect(SalaryAverager::Averager.new([2,4,12,48]).median).to eq(8)
  end

  it "averages for two, one, or no people" do
    expect(SalaryAverager::Averager.new([2,12]).average).to eq(7)
    expect(SalaryAverager::Averager.new([2]).average).to eq(2)
    expect { SalaryAverager::Averager.new([]).average }.not_to raise_exception
    expect(SalaryAverager::Averager.new([]).average).to be_nil
  end

  it "calculates median for two, one, or no people" do
    expect(SalaryAverager::Averager.new([2,12]).median).to eq(7)
    expect(SalaryAverager::Averager.new([2]).median).to eq(2)
    expect {
      SalaryAverager::Averager.new([]).median
    }.not_to raise_exception
    expect(SalaryAverager::Averager.new([]).median).to be_nil
  end


  it "doesn't report on small arrays" do
    expect(SalaryAverager::Averager.new([2,4]).report).to match(/too small/)
    expect(SalaryAverager::Averager.new([2]).report).to match(/too small/)
    expect(SalaryAverager::Averager.new([]).report).to match(/(no |none)/i)
  end

end

