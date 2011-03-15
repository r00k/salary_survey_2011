require 'rubygems'
require 'faster_csv'

class SalaryAverager

  def initialize(path_to_data)
    @data = FasterCSV.read(path_to_data)
    @data.shift
  end

  def average_salary
    salaries.inject(0) { |acc, s| acc += s } / salaries.size
  end

  def salaries
    @data.map { |entry| entry[1] }.map(&:to_f)
  end
end
