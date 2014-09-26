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
  def self.coordinate_to_location(lat, long)
    fips = "http://data.fcc.gov/api/block/find?latitude=#{lat}&longitude=#{long}&showall=false&format=json"
    result = RestClient.get fips
    parsed = JSON.parse(result.body)
    OpenStruct.new county: parsed["County"]["FIPS"][2..-1],
                   state: parsed["State"]["FIPS"],
                   tract: parsed["Block"]["FIPS"][5..10]
  end

  # Get the median income for the specified lat or long
  def self.getIncomeForCoordinate(lat, long)
    location = coordinate_to_location lat, long
    getIncomeForLocation(location.state, location.county, location.tract)
  end

  # Get the median income for the specified state and county
  def self.getIncomeForLocation(state, county, tract)
    existing_geo_region_in_census_tract = GeoRegion.find_by census_tract_id: "#{state}#{county}#{tract}"

    if existing_geo_region_in_census_tract
      existing_geo_region_in_census_tract.income_data
    else
      # Query the specified area
      url = "http://api.census.gov/data/2012/acs5?key=#{@key}&get=B17001_001E,B17001_002E,B19113_001E&for=tract:#{tract}&in=state:#{state}+county:#{county}"
      puts "url: #{url}"
      population_data = RestClient.get url

      puts "poverty_pop_data: #{population_data.body}"
      parsed_data = JSON.parse population_data.body

      {
          individuals_below_poverty_line: parsed_data[1][1],
          poverty_rate:  parsed_data[1][1].to_f / parsed_data[1][0].to_f,
          median_income: parsed_data[1][2],
          identifier: "#{state}#{county}#{tract}"
      }
    end
  end

  # Get the median income for the specified state and county
  def self.get_households_by_income_tier(lat, long)
    location = coordinate_to_location lat, long
    identifier = "#{location.state}#{location.county}#{location.tract}"

    existing_geo_region_in_census_tract = GeoRegion.find_by census_tract_id: identifier

    if existing_geo_region_in_census_tract
      existing_geo_region_in_census_tract.income_data
    else
      # Query the specified area
      to_get = {
          'B19001_002E' => '<10',
          'B19001_003E' => '<15',
          'B19001_004E' => '<20',
          'B19001_005E' => '<25',
          'B19001_006E' => '<30',
          'B19001_007E' => '<35',
          'B19001_008E' => '<40',
          'B19001_009E' => '<45',
          'B19001_010E' => '<50',
          'B19001_011E' => '<60',
          'B19001_012E' => '<75',
          'B19001_013E' => '<100',
          'B19001_014E' => '<125',
          'B19001_015E' => '<150',
          'B19001_016E' => '<200',
          'B19001_017E' => '>200',
      }
      url = "http://api.census.gov/data/2012/acs5?key=#{@key}&get=#{to_get.keys.join(',')}&for=tract:#{location.tract}&in=state:#{location.state}+county:#{location.county}"
      puts "url: #{url}"
      population_data = RestClient.get url

      parsed_data = JSON.parse population_data.body

      useful_data = {}
      Hash[parsed_data[0].zip(parsed_data[1])].each { |k, v| useful_data[to_get[k] || k] = v }

      useful_data.merge identifier: identifier
      useful_data
    end
  end
end

# main.rb
# require "./census"

# Just a few examples.  Use for testing.
#puts Census.getIncomeForCoordinate(39.758936,-104.974365) # Denver
#puts Census.getIncomeForCoordinate(39.9936, -105.0892) # San Antonio
