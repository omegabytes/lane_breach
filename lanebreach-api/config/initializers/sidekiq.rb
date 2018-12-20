# Set up the Sidekiq CRON schedule:
schedule_filename = 'config/schedule.yml'

if File.exist?(schedule_filename) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash(YAML.load_file(schedule_filename))
end
