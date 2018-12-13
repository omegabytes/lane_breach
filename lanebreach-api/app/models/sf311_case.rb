# == Schema Information
#
# Table name: sf311_cases
#
#  id                              :bigint(8)        not null, primary key
#  address                         :string
#  agency_responsible              :string
#  closed_date                     :datetime
#  lat                             :float
#  long                            :float
#  media_url                       :string
#  media_url_description           :string
#  neighborhoods_sffind_boundaries :string
#  point                           :geography({:srid point, 4326
#  point_address                   :string
#  point_city                      :string
#  point_state                     :string
#  point_zip                       :string
#  police_district                 :string
#  requested_datetime              :datetime
#  service_details                 :string
#  service_name                    :string
#  service_subtype                 :string
#  source                          :string
#  status_description              :string
#  status_notes                    :string
#  supervisor_district             :integer
#  updated_datetime                :datetime
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  service_request_id              :integer
#

class Sf311Case < ApplicationRecord
  SERVICE_SUBTYPES = {
    blocked_bike_lane: 'Blocking_Bicycle_Lane'
  }

  scope :bike_lane_blockage, -> { where(service_subtype: SERVICE_SUBTYPES[:blocked_bike_lane]) }
end
