class Api::MobileMetadataController < ApplicationController
  def index
    @mobile_metadata = MobileMetadatum.all
    render :index
  end

  def create
    @mobile_metadatum = MobileMetadatum.new(mobile_metadatum_params)
    if @mobile_metadatum.save
      render :show
    else
      render json: {'Error': "Error creating new mobile metadatum."}, status: :unprocessable_entity    
    end
  end

  private
  def mobile_metadatum_params
    params.fetch(:mobile_metadatum, {}).permit(:environment, :category, :token, :request_id)
  end
end
  