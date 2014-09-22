require 'rest_client'
require 'json'

API_KEY = 'AIzaSyCv1Lh2rQQI0QTLXNQS_DZJFbzrRX_EH2s'

module Vendors
  def get_vendors(lat, long, radius, healthy)
    request_url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=#{API_KEY}&location=#{lat},#{long}&radius=#{radius}&types=food"
    response = RestClient.get request_url
    
    if response.code == 200
      data = JSON.parse(response.to_str)
    else
      puts "ERROR: Request returned code #{response.code}"
      return nil
    end

    return response
  
  end
  
  module_function :get_vendors

end

puts Vendors.get_vendors(39.8044286,-105.0260933, 50000, 1)
