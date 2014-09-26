# census.rb

require 'net/http'
require 'rubygems'
require 'json'
require 'rest_client'

class Census

  # The variables to be returned from the query
  @variables = "ST,COUNTY,OPTAX,EMP,PAYANN"

  # The industries to query (all)
  @sector = "*"

  # The API key.  Registered to ryan.green@kyrus-tech.com
  # This can be updated using the form at:
  # http://www.census.gov/data/developers/data-sets/economic-census.html
  @key = ENV["CENSUS_API_KEY"]

  def initialize
    @tract_infos = {}
  end

  # Get the median salary from all salaries in the specified array
  def self.getMedian(salaries)
    sorted = salaries.sort
    len = sorted.length
    return (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end

  # Get the message body from the specified url
  def self.getUrl(url)
    parsed_url = URI.parse(url)
    req = Net::HTTP::Get.new(parsed_url.to_s)
    res = Net::HTTP.start(parsed_url.host, parsed_url.port) { |http|
      http.request(req)
    }
    return res.body
  end

  def get_income_for_geo_region(geo_region)
    
  end

  # Get the median income for the specified lat or long
  def getIncomeForCoordinate(lat, long)
    fips = "http://data.fcc.gov/api/block/find?latitude=#{lat}&longitude=#{long}&showall=false&format=json"
    result = RestClient.get fips
    parsed = JSON.parse(result.body)
    county = parsed["County"]["FIPS"][2..-1]
    state = parsed["State"]["FIPS"]
    block = parsed["Block"]["FIPS"]

    tract = block[5..10]

    identifier = "#{state}#{county}#{tract}"
    puts "tract_infos: #{@tract_infos}"
    puts "tract_infos[identifier]: #{@tract_infos[identifier]}"
    puts "identifier: #{identifier}"
    @tract_infos[identifier] ||= Census.getIncomeForLocation(state, county, tract)

    @tract_infos[identifier]
  end

  # Get the median income for the specified state and county
  def self.getIncomeForLocation(state, county, tract)
    total_payroll = 0 # The total payroll amount for the area
    total_employees = 0 # The total number of employees for the area
    all_salaries = Array.new # Container of all employees salaries

    # Query the specified area
    location = "county:#{county}&in=state:#{state}"
    # census = "http://api.census.gov/data/2007/ewks?get=" + @variables + "&for=" + location + "&NAICS2007=" + @sector + "&key=" + @key
    url = "http://api.census.gov/data/2012/acs5?key=#{@key}&get=B17001_001E,B17001_002E,B19113_001E&for=tract:#{tract}&in=state:#{state}+county:#{county}"
    puts "url: #{url}"
    population_data = RestClient.get url
    # poverty_population_data = RestClient.get "http://api.census.gov/data/2012/acs5?key=#{@key}&get=B17001_002E&for=tract:#{tract}&in=state:#{state}+county:#{county}"
    # median_income_data = RestClient.get "http://api.census.gov/data/2012/acs5?key=#{@key}&get=B19113_001E&for=tract:#{tract}&in=state:#{state}+county:#{county}"

    puts "poverty_pop_data: #{population_data.body}"
    parsed_data = JSON.parse population_data.body
    {
        poverty_rate: parsed_data[1][1].to_f / parsed_data[1][0].to_f,
        median_income: parsed_data[1][2]
    }

    # result = self.getUrl(census)
    # if result.to_s == ""
    #   # No results
    #   return 0
    # end
    #
    # # Parse the results
    # # A line can be returned for each sector (NAICS) and tax type (OPTAX)
    # # The first line is a header, so it is skipped
    # lines = result.split(' ')
    # for n in 1..(lines.length-1)
    #
    #   # Split a line into tokens.  Each token is a variable for an entry.
    #   tokens = lines[n].split(',')
    #
    #   # Parse out the employees and payroll variables
    #   employees = tokens[3].gsub(/\s|"|'/, '').to_i
    #   payroll = tokens[4].gsub(/\s|"|'/, '').to_i * 1000
    #
    #   # Prevent divide by zero by filtering out erroneous entries
    #   if employees == 0
    #     next
    #   end
    #
    #   # Keep count of the total employees and payroll.
    #   # Use for calculating the average.
    #   total_employees = total_employees + employees
    #   total_payroll = total_payroll + payroll
    #
    #   # Calculate the average salary.  Currently this is not
    #   # needed, but it is much less resource intensive than
    #   # calculating the median, so it may be of interest to
    #   # use this instead.  I.e., leaving it here for now.
    #   avg_salary = payroll / employees
    #
    #   # Push the average salary for all employees in the sector.
    #   for employee in 1..employees
    #     all_salaries.push(avg_salary)
    #   end
    # end
    #
    # # Calculate the average and the median.  Only the median
    # # is currently used.  See comment above.
    # avg = total_payroll / total_employees
    # median = self.getMedian(all_salaries)
    # return median
  end
end

# main.rb
# require "./census"

# Just a few examples.  Use for testing.
#puts Census.getIncomeForCoordinate(39.758936,-104.974365) # Denver
#puts Census.getIncomeForCoordinate(39.9936, -105.0892) # San Antonio
