require 'csv'

# Seed the SF 311 cases table with blocked bike lane incidents
# from April 2018 onward:
blocked_lane_cases_csv =
  Sf311CaseService.get_blocked_bike_lane_case_data(
    from_datetime: Date.new(2018, 4, 1),
    limit: 5000,
    format: :csv
  )

cases_to_import = []

CSV.parse(blocked_lane_cases_csv, headers: true) do |row|
  cases_to_import << Sf311Case.new(row.to_h)
end

Sf311Case.import!(cases_to_import)
