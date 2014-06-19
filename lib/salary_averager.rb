require 'rubygems'
require 'csv'

class SalaryAverager

  class Selector
    def self.salary_column=(column)
      @@column = column
    end

    def self.salaries_from(rows)
      rows.map { |row| row[@@column].to_i }
    end
  end


  class Averager
    def initialize(array)
      @array = array.map(&:to_i)
    end

    def average
      @array.inject(&:+) / @array.size
    end

    def median
      size = @array.size
      if size.odd?
        @array.sort[size / 2]
      else
        (@array.sort[size / 2 - 1] + @array.sort[size / 2]) / 2
      end
    end

    def report
      return too_small_message if sample_size_too_small?
      "#{@array.size} respondents.  Average: #{average}.   Median: #{median}."
    end

    def sample_size_too_small?
      @array.size < 3
    end

    def too_small_message
      case count = @array.size
      when 0
        "No respondents!"
      when 1, 2
        "Only #{count} respondent(s) -- sample size too small."
      end
    end
  end


  def initialize(file_path)
    @data = CSV.read(file_path)
    column_headers = @data.shift
    parse_headers(column_headers)
  end

  def parse_headers(headers)
    unless headers.find_index { |entry| /salary/ =~ entry }
      raise 'Spreadsheet must have column headers that include "work status" or "freelancer", "salary", and "tell other developers".'
    end
    @employment_column      = headers.find_index { |entry| /work status/i =~ entry || /freelancer/i =~ entry }
    @manager_column         = headers.find_index { |entry| /tell other developers/i =~ entry }
    Selector.salary_column  = headers.find_index { |entry| /salary/i =~ entry }
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
    Averager.new(Selector.salaries_from(rows))
  end

  def salary_report
    "#{@data.size} people responded to the survey.\n" <<
      "Freelancers:     #{salaries(freelancers).report}\n" <<
      "Non-freelancers: #{salaries(non_freelancers).report}\n" <<
      "Managers:        #{salaries(managers).report}\n" <<
      "Non-managers:    #{salaries(non_managers).report}"
  end

end


file_path = File.expand_path('../data/data.csv', File.dirname(__FILE__))
puts SalaryAverager.new(file_path).salary_report
