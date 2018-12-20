class BikewayNetworkSerializer
  include FastJsonapi::ObjectSerializer

  attributes :gid, :install_yr, :symbology, :streetname, :dist
end
