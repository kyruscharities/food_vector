require 'rest_client'
require 'json'
require 'cgi'

module Vendors
  def get_food_sources_by_region(analysis)
    Rails.logger.info "Finding locations of #{FoodSource.all.count} food sources"
    FoodSource.all.each do |fs|
      Rails.logger.info "Finding all locations of [#{fs.business_name}] near [#{analysis.geo_region}]"
      Vendors.get_vendors(fs, analysis.geo_region)
    end
  end

  def get_vendors(fs, geo, pagetok='')
    request_url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?" \
                  "key=#{ENV.fetch "GOOGLEMAPS_API_KEY"}" \
                  "&location=#{geo.center_lat},#{geo.center_lon}" \
                  "&types=food" \
                  "&name=#{CGI.escape(fs.business_name)}" \
                  "&rankby=distance"

    if pagetok != ""
      request_url = "#{request_url}&pagetoken=#{pagetok}"
    end

    puts "Attempting Requst to: #{request_url}"

    begin
      response = RestClient.get request_url
      puts "Results: #{response}"
    rescue => e
      puts "ERROR: Unhandled Exception - #{e}"
    end

    if response.code == 200
      data = JSON.parse(response.to_str)

      if data['results'].length == 0
        puts "No results found for #{fs.business_name}. Breaking..."
        return
      end

      for loc in data['results']
        puts "Located Food Source: #{loc}"

        loc_lat = loc['geometry']['location']['lat']
        loc_lon = loc['geometry']['location']['lng']

        if loc_lat > (geo.nw_lat + 0.1) or loc_lat < (geo.se_lat - 0.1)
          puts "breaking loop because too big or small of latitude"
          return
        elsif loc_lon < (geo.nw_lon - 0.1) or loc_lon > (geo.se_lon + 0.1)
          puts "breaking loop because too big or small of long"
          return
        end

        LocatedFoodSource.find_or_create_by! lat: loc_lat,
                                             lon: loc_lon,
                                             price_rank: loc['price_level'],
                                             food_source_id: fs.id
      end
    else
      puts "ERROR: Request returned code - #{response.code}"
    end

    Vendors.get_vendors(fs, geo, pagetok=data['next_page_token']) if data['next_page_token']
  end

  module_function :get_food_sources_by_region
  module_function :get_vendors
end
