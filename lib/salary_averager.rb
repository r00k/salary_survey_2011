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

end
