class Api::BikewayNetworksController < ApplicationController
  def nearest_network
    if params[:lat].nil? || params[:long].nil?
      render json: {'Error': "Must provide 'lat' and 'long' as query parameters."}, status: :unprocessable_entity
    else
      bikeway_network = BikewayNetwork.nearest(params[:lat], params[:long])

      render json: BikewayNetworkSerializer.new(bikeway_network), status: :ok
    end
  end
end
