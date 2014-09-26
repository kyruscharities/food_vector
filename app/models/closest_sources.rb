require 'geocoder'

class ClosestSources
  def test
    gr = GeoRegion.new
    gr.nw_lat=38.9601405+0.1
    gr.nw_lon=-77.3921701-0.1
    gr.se_lat=38.9601405-0.1
    gr.se_lon=-77.3921701+0.1

    return miles_to_nearest_sources(gr)
  end

  def fake_data
    # Put in fake sources, since we don't have any to work with yet
    @healthy_sources = []
    @unhealthy_sources = []
    for lat in (-10...10)
      for lon in (-10...10)
        lfs = LocatedFoodSource.new()
        lfs.lat = 38.9601405+lat
        lfs.lon = -77.3921701+lon
        @healthy_sources.push(lfs)
        lfs = LocatedFoodSource.new()
        lfs.lat = 38.9601405+0.3*lat
        lfs.lon = -77.3921701+0.3*lon
        @unhealthy_sources.push(lfs)
      end
    end
  end

  def initialize(healthy_sources_in, unhealthy_source_in)

    @healthy_sources = healthy_sources_in
    @unhealthy_sources = unhealthy_source_in

    # Index the located food sources for use with Kdtree
    @healthy_sources_indexed = []
    @healthy_sources.each_with_index { |lfs, i|
      @healthy_sources_indexed.push([lfs.lat, lfs.lon, i])
    }

    @unhealthy_sources_indexed = []
    @unhealthy_sources.each_with_index { |lfs, i|
      @unhealthy_sources_indexed.push([lfs.lat, lfs.lon, i])
    }

    # Create Kdtrees from the sources
    @healthy_tree = Kdtree.new(@healthy_sources_indexed)
    @unhealthy_tree = Kdtree.new(@unhealthy_sources_indexed)
  end

  def nearest_source_helper(geo_region, tree, sources)
    geo_region.calculate_center_point()
    index = tree.nearest(geo_region.center_lat, geo_region.center_lon)
    return sources[index]
  end

  def nearest_healthy_source(geo_region)
    return nearest_source_helper(geo_region, @healthy_tree, @healthy_sources)
  end

  def nearest_unhealthy_source(geo_region)
    return nearest_source_helper(geo_region, @unhealthy_tree, @unhealthy_sources)
  end

  def nearest_sources(geo_region)
    return [nearest_healthy_source(geo_region), nearest_unhealthy_source(geo_region)]
  end

  def miles_to_nearest_sources(geo_region)
    (nearest_healthy, nearest_unhealthy) = nearest_sources(geo_region)
    miles_to_healthy = Geocoder::Calculations.distance_between(geo_region.center_point_as_array, nearest_healthy.as_array, :units => :mi)
    miles_to_unhealthy = Geocoder::Calculations.distance_between(geo_region.center_point_as_array, nearest_unhealthy.as_array, :units => :mi)
    return [miles_to_healthy, miles_to_unhealthy]
  end

end