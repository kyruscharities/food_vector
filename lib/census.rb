# census.rb

require 'net/http'
require 'rubygems'
require 'json'

module Census

  # The variables to be returned from the query
  @variables = "ST,COUNTY,OPTAX,EMP,PAYANN"

  # The industries to query (all)
  @sector = "*"

  # The API key.  Registered to ryan.green@kyrus-tech.com
  # This can be updated using the form at:
  # http://www.census.gov/data/developers/data-sets/economic-census.html
  @key = "92d57a5b97faad86177b0db820e4280e4bb24deb"

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
    res = Net::HTTP.start(parsed_url.host, parsed_url.port) {|http|
        http.request(req)
    }
    return res.body
  end

  # Get the median income for the specified lat or long
  def self.getIncomeForCoordinate(lat, long)
    fips = "http://data.fcc.gov/api/block/find?latitude=#{lat}&longitude=#{long}&showall=false&format=json"
    result = self.getUrl(fips)
    parsed = JSON.parse(result)
    county = parsed["County"]["FIPS"][2..-1]
    state = parsed["State"]["FIPS"]
    return self.getIncomeForLocation(state, county)
  end

  # Get the median income for the specified state and county
  def self.getIncomeForLocation(state, county)
    total_payroll = 0         # The total payroll amount for the area
    total_employees = 0       # The total number of employees for the area
    all_salaries = Array.new  # Container of all employees salaries

    # Query the specified area
    location = "county:#{county}&in=state:#{state}"
    census = "http://api.census.gov/data/2007/ewks?get=" + @variables + "&for=" + location + "&NAICS2007=" + @sector + "&key=" + @key
    result = self.getUrl(census)
    if result.to_s == ""
      # No results
      return 0
    end

    # Parse the results
    # A line can be returned for each sector (NAICS) and tax type (OPTAX)
    # The first line is a header, so it is skipped
    lines = result.split(' ')
    for n in 1..(lines.length-1)

      # Split a line into tokens.  Each token is a variable for an entry.
      tokens = lines[n].split(',')

      # Parse out the employees and payroll variables
      employees = tokens[3].gsub(/\s|"|'/, '').to_i
      payroll = tokens[4].gsub(/\s|"|'/, '').to_i * 1000

      # Prevent divide by zero by filtering out erroneous entries
      if employees == 0
        next
      end

      # Keep count of the total employees and payroll.
      # Use for calculating the average.
      total_employees = total_employees + employees
      total_payroll = total_payroll + payroll

      # Calculate the average salary.  Currently this is not
      # needed, but it is much less resource intensive than
      # calculating the median, so it may be of interest to
      # use this instead.  I.e., leaving it here for now.
      avg_salary = payroll / employees

      # Push the average salary for all employees in the sector.
      for employee in 1..employees
        all_salaries.push(avg_salary)  
      end
    end

    # Calculate the average and the median.  Only the median
    # is currently used.  See comment above.
    avg = total_payroll / total_employees
    median = self.getMedian(all_salaries)
    return median
  end
end

# main.rb
# require "./census"

# Just a few examples.  Use for testing.
#puts Census.getIncomeForCoordinate(39.758936,-104.974365) # Denver
#puts Census.getIncomeForCoordinate(39.9936, -105.0892) # San Antonio
