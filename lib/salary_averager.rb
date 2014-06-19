require 'rubygems'
require 'csv'

class Array
  def average
    self.map(&:to_i).inject(&:+) / self.size
  end

  def median
    size = self.size
    if size.odd?
      self.sort[size / 2]
    else
      (self.sort[size / 2 - 1] + self.sort[size / 2]) / 2
    end
  end

  def report
    return too_small_message if sample_size_too_small?
    "#{self.size} respondents.  Average: #{self.average}.   Median: #{self.median}."
  end

  def sample_size_too_small?
    self.size < 3
  end

  def too_small_message
    case count = self.size
    when 0
      "No respondents!"
    when 1, 2
      "Only #{count} respondent(s) -- sample size too small."
    end
  end
end

class SalaryAverager

  class SalarySelector
    def salary_column=(column)
      @column = column
    end

    def salary(rows)
      rows.map { |row| row[@column].to_i }
    end
  end

  def initialize(file_path)
    @data = CSV.read(file_path)
    @selector = SalarySelector.new
    column_headers = @data.shift
    parse_headers(column_headers)
  end

  def parse_headers(headers)
    unless headers.find_index { |entry| /salary/ =~ entry }
      raise 'Spreadsheet must have column headers that include "work status", "salary", and "tell other developers".'
    end
    @employment_column      = headers.find_index { |entry| /work status/i =~ entry }
    @manager_column         = headers.find_index { |entry| /tell other developers/i =~ entry }
    @selector.salary_column = headers.find_index { |entry| /salary/i =~ entry }
  end

  def entries
    @data.size
  end

  def freelancers
    @data.select { |entry| /freelance/i =~ entry[@employment_column] }
  end

  def non_freelancers
    @data.reject { |entry| /freelance/i =~ entry[@employment_column] }
  end

  def managers
    @data.select { |entry| entry[@manager_column] == "Yes" }
  end

  def non_managers
    @data.select { |entry| entry[@manager_column] == "No" }
  end

  def salaries(rows)
    @selector.salary(rows)
  end

  def salary_report
    "We had #{entries} respondents in our survey.\n" +
      "Freelancers:     #{salaries(freelancers).report}\n" +
      "Non-freelancers: #{salaries(non_freelancers).report}\n" +
      "Managers:        #{salaries(managers).report}\n" +
      "Non-managers:    #{salaries(non_managers).report}"
  end

end

file_path = File.expand_path('../../data/data.csv', __FILE__)
puts SalaryAverager.new(file_path).salary_report
