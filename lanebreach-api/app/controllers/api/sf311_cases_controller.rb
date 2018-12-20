class Api::Sf311CasesController < ApplicationController
  def index
    lane_blockages_query = Sf311Case.bike_lane_blockage.includes(:sf311_case_metadatum)

    if params[:start_time]
      lane_blockages_query =
        lane_blockages_query.where('requested_datetime >= ?', params[:start_time])
    end

    if params[:end_time]
      lane_blockages_query =
        lane_blockages_query.where('requested_datetime <= ?', params[:end_time])
    end

    paginated_query = paginate(lane_blockages_query)

    render json: Sf311CaseSerializer.new(paginated_query, include: [:sf311_case_metadatum])
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

  private

  def sf311_case_params
    # TODO: Be more explicit about which attributes are supported
    params.
      fetch(:sf311_case, {}).
      permit(Sf311Case.attribute_names - %w[id created_at updated_at])
  end
end
