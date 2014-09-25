class ClosestSources
  def test
    gr = GeoRegion.new
    gr.nw_lat=38.9601405+0.1
    gr.nw_lon=-77.3921701-0.1
    gr.se_lat=38.9601405-0.1
    gr.se_lon=-77.3921701+0.1

    return nearest_sources(gr)
  end

  def initialize()
    # Put in fake sources, since we don't have any to work with yet

    @healthy_sources = []
    @unhealthy_sources = []
    for lat in (-10...10)
      for lon in (-10...10)
        @healthy_sources.push(LocatedFoodSource.new())
        @unhealthy_sources.push(LocatedFoodSource.new())
      end
    end

    # Create fake locations for these sources
    @healthy_sources_indexed = []
    i = 0
    for source in @healthy_sources
      @healthy_sources_indexed.push([38.9601405+lat, -77.3921701+lon, i])
      i += 1
    end

    @unhealthy_sources_indexed = []
    i = 0
    for source in @unhealthy_sources
      @unhealthy_sources_indexed.push([38.9601405+0.1*lat, -77.3921701+0.1*lon, i])
      i += 1
    end

    # Create Kdtrees from the sources
    @healthy_tree = Kdtree.new(@healthy_sources_indexed)
    @unhealthy_tree = Kdtree.new(@unhealthy_sources_indexed)
  end

  def walking_distance_to_located_food_source(geo_region, located_food_source)
    # Fill this in with a call to Google Maps API?
  end

  def nearest_source_helper(geo_region, tree, sources)
    lat = geo_region.nw_lat/2 + geo_region.se_lat/2
    lon = geo_region.nw_lon/2 + geo_region.se_lon/2
    index = tree.nearest(lat, lon)
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

end