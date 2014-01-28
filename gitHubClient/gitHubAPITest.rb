require 'json'
require 'pp'

require_relative "./GitHubClient"

env         = ENV['BACKUP_ENV'] || 'prod'
config_file = "../config/#{env}.backup.json"
config      = JSON.parse(IO.read(config_file))['github'];

@client = GitHubClient.new(config["username"], config["token"]).client

repo   = @client.repo config["backup"]["repo"]
file   = "#{config["backup"]["folder"]}/api_test.json"
branch = config["backup"]["branch"]

begin
	contents = @client.contents(repo.full_name, :path => file, :branch => branch).to_hash
rescue Octokit::NotFound => e  
  puts "404 : #{file} not found in #{repo.full_name}"
  puts e.message
rescue Exception => e
	puts "you are screwed"
  puts "An error of type #{e.class} happened, message is #{e.message}"
end

pp contents