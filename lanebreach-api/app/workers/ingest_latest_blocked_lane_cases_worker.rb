class IngestLatestBlockedLaneCasesWorker
  include Sidekiq::Worker

  def perform
    # 1. Fetch timestamp of most recently retrieved case
    #   - Store in either Redis or retrieve most recent date from cases table
    most_recent_case_timestamp = Sf311Case.last.requested_datetime

    # 2. Fetch all blocked bike lane cases between the above timestamp + 1 minute
    #    and the current date
    blocked_lane_cases_csv =
      Sf311CaseService.get_blocked_bike_lane_case_data(
        from_datetime: most_recent_case_timestamp + 1.minute

        # TODO: Figure out record limit keeping in mind that seeds.rb currently
        # adds the first 50 records since April 2018
        # limit: 5000,

        format: :csv
      )

    # 3. Ingest the records retrieved in step 2 (may want to use and/or
    #    move the code used to do this in db/seeds.rb)
    Sf311Case.ingest_csv_case_data(blocked_lane_cases_csv)
  end
end
