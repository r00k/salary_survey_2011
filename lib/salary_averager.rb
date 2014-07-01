require 'rubygems'
require 'csv'

# Usage:
# file_path = File.expand_path('data/data2013.csv', File.dirname(__FILE__))
# puts SalaryAverager.new(file_path).salary_report
class SalaryAverager

  class Averager < Array
    def average
      return nil if empty?
      inject(&:+) / size
    end

    def median
      return nil if empty?
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


  class MalformedSpreadsheetError < ArgumentError
    def message
      msg = "Spreadsheet must have column headers that include 'work status' or 'freelance',"
      msg += "'manage' or 'tell other developers', and 'salary'.\n"
      msg + super()
    end
  end


  def initialize(file_path)
    @data = CSV.read(file_path)
    process_headers(@data.shift)
  end

  def process_headers(headers)
    @employment_column = headers.find_index { |entry| /(work status|freelance)/i =~ entry }
    @manager_column    = headers.find_index { |entry| /(manage|tell other developers)/i =~ entry }
    @skill_column      = headers.find_index { |entry| /(skill|ability)/i =~ entry }
    @salary_column     = headers.find_index { |entry| /salary/i =~ entry }

    unless @employment_column && @manager_column && @salary_column # skill column is optional
      e = MalformedSpreadsheetError.new
      raise e
    end
  end

  def entry_count
    @data.size
  end

  def freelancers
    @data.select { |row| /freelance/i =~ row[@employment_column] }
  end

  def non_freelancers
    @data.reject { |row| /freelance/i =~ row[@employment_column] }
  end

  def managers
    @data.select { |row| row[@manager_column] == "Yes" }
  end

  def non_managers
    @data.select { |row| row[@manager_column] == "No" }
  end

  def salaries_from(rows)
    rows.map { |row| row[@salary_column].to_i }
  end

  def skill_ratings
    if @skill_column
      @data.map { |row| row[@skill_column] }.map(&:to_f)
    end
  end

  def freelancer_salaries
    salaries_from(freelancers)
  end

  def non_freelancer_salaries
    salaries_from(non_freelancers)
  end

  def manager_salaries
    salaries_from(managers)
  end

  def non_manager_salaries
    salaries_from(non_managers)
  end

  def report(salaries)
    Averager.new(salaries).report
  end

  def salary_report
    "#{entry_count} people responded to the survey.\n" <<
      "Freelancers:     #{report(freelancer_salaries)}\n" <<
      "Non-freelancers: #{report(non_freelancer_salaries)}\n" <<
      "Managers:        #{report(manager_salaries)}\n" <<
      "Non-managers:    #{report(non_manager_salaries)}"
  end

end
