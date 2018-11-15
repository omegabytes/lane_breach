class Api::Sf311CasesController < ApplicationController
  def index
    client = Sf311CasesService.new
    data = client.get_data
    render json: data.to_json, status: :ok
  end
end
    