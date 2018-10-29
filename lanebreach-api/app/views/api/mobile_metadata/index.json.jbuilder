json.array! @mobile_metadata do |mobile_metadatum|
    json.extract! mobile_metadatum, :id, :created_at, :updated_at, :environment, :category, :token, :request_id
end
  