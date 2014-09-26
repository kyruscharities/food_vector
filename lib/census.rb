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

  # Get the median income for the specified lat or long
  def self.getIncomeForCoordinate(lat, long)
    fips = "http://data.fcc.gov/api/block/find?latitude=#{lat}&longitude=#{long}&showall=false&format=json"
    result = RestClient.get fips
    parsed = JSON.parse(result.body)
    county = parsed["County"]["FIPS"][2..-1]
    state = parsed["State"]["FIPS"]
    block = parsed["Block"]["FIPS"]
    tract = block[5..10]

    Census.getIncomeForLocation(state, county, tract)
  end

  # Get the median income for the specified state and county
  def self.getIncomeForLocation(state, county, tract)
    existing_geo_region_in_census_tract = GeoRegion.find_by census_tract_id: "#{state}#{county}#{tract}"

    if existing_geo_region_in_census_tract
      existing_geo_region_in_census_tract.income_data
    else
      total_payroll = 0 # The total payroll amount for the area
      total_employees = 0 # The total number of employees for the area
      all_salaries = Array.new # Container of all employees salaries

      # Query the specified area
      url = "http://api.census.gov/data/2012/acs5?key=#{@key}&get=B17001_001E,B17001_002E,B19113_001E&for=tract:#{tract}&in=state:#{state}+county:#{county}"
      puts "url: #{url}"
      population_data = RestClient.get url

      puts "poverty_pop_data: #{population_data.body}"
      parsed_data = JSON.parse population_data.body

      {
          poverty_rate: parsed_data[1][1].to_f / parsed_data[1][0].to_f,
          median_income: parsed_data[1][2],
          identifier: "#{state}#{county}#{tract}"
      }
    end
  end
end

# main.rb
# require "./census"

# Just a few examples.  Use for testing.
#puts Census.getIncomeForCoordinate(39.758936,-104.974365) # Denver
#puts Census.getIncomeForCoordinate(39.9936, -105.0892) # San Antonio
