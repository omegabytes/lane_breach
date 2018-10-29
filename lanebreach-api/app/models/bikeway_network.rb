class BikewayNetwork < ApplicationRecord
  def self.nearest(lat, long)
    meters = 3

    BikewayNetwork.select("gid, install_yr, symbology, streetname, st_DistanceSphere(geom, ST_MakePoint(#{long}, #{lat})) as dist")
    .where("st_DistanceSphere(geom, ST_MakePoint(?, ?)) <= #{meters}", long, lat)
    .order('dist')
    .limit(1)
    .first
  end
end
