require 'rest_client'
require 'json'

API_KEY = 'AIzaSyCv1Lh2rQQI0QTLXNQS_DZJFbzrRX_EH2s'

module Vendors
  def get_vendors(lat, long, radius, healthy, keyword='')
    if radius > 50000
      puts "Radius #{radius} is larger than 50000 meter limit. Truncating..."
      radius = 50000
    end
    
    request_url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?" \
                  "key=#{API_KEY}" \
                  "&location=#{lat},#{long}" \
                  "&radius=#{radius}"\
                  "&types=food"
    
    if keyword
      request_url = "#{request_url}&keyword=#{keyword}"
    end
     
    puts "Attempting Requst to: #{request_url}"

    begin
      response = RestClient.get request_url
    rescue => e
      puts "ERROR: Unhandled Exception - #{e}"
      return nil
    end

    if response.code == 200
      data = JSON.parse(response.to_str)
      vendors = Array.new

      for location in data['results']
        puts "Located Food Source: #{location}"
        x = LocatedFoodSource.new business_name: location['name'],
                                  lat: location['geometry']['location']['lat'], 
                                  lon: location['geometry']['location']['lng'], 
                                  healthy: healthy, 
                                  price_rank: location['price_level']  
        vendors << x
      end
      
      puts "Found #{vendors.length} Food Sources"
      return vendors

    else
      puts "ERROR: Request returned code - #{response.code}"
    end
  
    return nil 
  end
  
  module_function :get_vendors
end
