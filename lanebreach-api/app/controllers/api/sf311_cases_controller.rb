class Api::Sf311CasesController < ApplicationController
  def index
    data = Sf311CaseService.get_blocked_bike_lane_cases
    render json: data, status: :ok
  end

  def create
    @sf311_case = Sf311Case.new(sf311_case_params)

    if @sf311_case.save
      # TODO: Perform this request in the background (e.g., Resque, Sidekiq)
      # NOTE: This functionality is currently disabled in non-prod environments
      Sf311CaseService.create_case(sf311_case_params)

      render :show
    else
      render json: { 'Error': 'Error creating new 311 case' }, status: :unprocessable_entity
    end
  end

  def bike_lane_blockages
    lane_blockages_query = Sf311Case.bike_lane_blockage

    if params[:start_time]
      lane_blockages_query =
        lane_blockages_query.where('requested_datetime >= ?', params[:start_time])
    end

    if params[:end_time]
      lane_blockages_query =
        lane_blockages_query.where('requested_datetime <= ?', params[:end_time])
    end

    paginate json: lane_blockages_query, per_page: 10
  end

  private

  def sf311_case_params
    # TODO: Be more explicit about which attributes are supported
    params.
      fetch(:sf311_case, {}).
      permit(Sf311Case.attribute_names - [:id, :created_at, :updated_at])
  end
end
