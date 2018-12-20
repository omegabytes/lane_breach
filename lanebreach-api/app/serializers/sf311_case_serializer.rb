class Sf311CaseSerializer
  include FastJsonapi::ObjectSerializer

  set_id :service_request_id

  ATTRIBUTES_TO_EXCLUDE = %w[
    id
    service_details
    created_at
    updated_at
  ]

  attributes *(Sf311Case.attribute_names - ATTRIBUTES_TO_EXCLUDE)

  has_one :sf311_case_metadatum

  attribute :service_details do |object|
    if object.service_details == 'Parking Enforcement'
      nil
    else
      service_detail_components = object.service_details.split(' - ')

      make_and_model = service_detail_components.second
      downcased_make_and_model = make_and_model.downcase

      if downcased_make_and_model.include?('uber')
        tnc = 'uber'
      elsif downcased_make_and_model.include?('lyft')
        tnc = 'lyft'
      elsif downcased_make_and_model.include?('taxi')
        tnc = 'taxi'
      else
        tnc = nil
      end


      # "White - Toyota Camry - Bchr603"
      {
        color: service_detail_components.first,
        make_and_model: service_detail_components.second,
        tnc: tnc,
        license: service_detail_components.third
      }
    end
  end
end
