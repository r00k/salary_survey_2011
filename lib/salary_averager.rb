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


  class Averager < Array
    def average
      inject(&:+) / size
    end

    def median
      if size.odd?
        sort[size / 2]
      else
        (sort[size / 2 - 1] + sort[size / 2]) / 2
      end
    end

    def report
      return too_small_message if sample_size_too_small?
      "#{size} respondents.  Average: #{average}.   Median: #{median}."
    end

    def sample_size_too_small?
      size < 3
    end

    def too_small_message
      case count = size
      when 0
        "No respondents!"
      when 1, 2
        "Sample size too small for anonymous reporting."
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
