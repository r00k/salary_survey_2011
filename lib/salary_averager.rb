require 'rubygems'
require 'faster_csv'

class SalaryAverager

  def initialize(path_to_data)
    @data = FasterCSV.read(path_to_data)
    @data.shift
  end

  def freelancer_salaries
    @data.select { |entry| entry[4] == "Yes" }.map { |entry| entry[1] }.map(&:to_f)
  end

  def non_freelancer_salaries
    @data.select { |entry| entry[4] == "No" }.map { |entry| entry[1] }.map(&:to_f)
  end

  def manager_salaries
    @data.select { |entry| entry[3] == "Yes" }.map { |entry| entry[1] }.map(&:to_f)
  end

  def non_manager_salaries
    @data.select { |entry| entry[3] == "No" }.map { |entry| entry[1] }.map(&:to_f)
  end

  def skill_ratings
    @data.map { |entry| entry[2] }.map(&:to_f)
  end

end

class Array
  def average
    self.inject(&:+) / self.size.to_f
  end
end


sa = SalaryAverager.new('data/data.csv')

puts "Average freelancer salary: %d"     % sa.freelancer_salaries.average
puts "Average non-freelancer salary: %d" % sa.non_freelancer_salaries.average
puts "Average manager salary: %d"        % sa.manager_salaries.average
puts "Average non-manager salary: %d"    % sa.non_manager_salaries.average
puts "Average skill rating: %d"    % sa.skill_ratings.average
