# == Schema Information
#
# Table name: mobile_metadata
#
#  id          :bigint(8)        not null, primary key
#  category    :string
#  environment :string
#  token       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  request_id  :string
#

class MobileMetadatum < ApplicationRecord
end
