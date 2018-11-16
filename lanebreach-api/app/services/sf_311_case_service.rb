require 'soda/client'

class Sf311CaseService
  def initialize 
    @client = SODA::Client.new({:domain => "data.sfgov.org", :app_token => "QPCu2zzyc3jV5UkGfpOrGnXi7"})
    @dataset_id = "ktji-gk7t"
  end

  def get_data
    results = @client.get(@dataset_id, :$limit => 50, :service_subtype => "Blocking_Bicycle_Lane", :select => "*")
    puts "Got #{results.count} results. Dumping first results:"
    results.first.each do |k, v|
    puts "#{key}: #{value}"
  end
end