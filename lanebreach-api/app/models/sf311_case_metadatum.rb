# == Schema Information
#
# Table name: sf311_case_metadata
#
#  id             :bigint(8)        not null, primary key
#  bike_lane_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  sf311_case_id  :bigint(8)
#
# Indexes
#
#  index_sf311_case_metadata_on_sf311_case_id  (sf311_case_id)
#
# Foreign Keys
#
#  fk_rails_...  (sf311_case_id => sf311_cases.id)
#

class Sf311CaseMetadatum < ApplicationRecord
  belongs_to :sf311_case

  def self.create_metadata(sf311_case)
    bikeway_network = BikewayNetwork.nearest(sf311_case.lat, sf311_case.long)

    if bikeway_network.present?
      Sf311CaseMetadatum.create!(bike_lane_type: bikeway_network.symbology, sf311_case: sf311_case)
    end
  end
end
