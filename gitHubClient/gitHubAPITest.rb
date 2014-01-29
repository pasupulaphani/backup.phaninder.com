require 'json'
require 'pp'
require 'base64'

require_relative "./GitHubClient"

env         = ENV['BACKUP_ENV'] || 'prod'
config_file = "../config/#{env}.backup.json"
config      = JSON.parse(IO.read(config_file))['github'];

@client = GitHubClient.new(config["username"], config["token"]).client

repo   = @client.repo config["backup"]["repo"]
ref = 'heads/master'
file   = "#{config["backup"]["folder"]}/api_test.json"
branch = config["backup"]["branch"]

begin
	file_info = @client.contents(repo.full_name, :path => file, :branch => branch).to_hash
rescue Octokit::NotFound => e  
  puts "404 : #{file} not found in #{repo.full_name}"
  puts e.message
rescue Exception => e
	puts "you are screwed"
  puts "An error of type #{e.class} happened, message is #{e.message}"
end

# pp file_info

pp "Content before commit : #{file_info[:path]}"
pp Base64.decode64(file_info[:content]).delete("\n")

new_content        = "test3"
sha_latest_commit  = @client.ref(repo.full_name, ref).object.sha
sha_base_tree      = @client.commit(repo.full_name, sha_latest_commit).commit.tree.sha
blob_sha           = @client.create_blob(repo.full_name, Base64.encode64(new_content), "base64")
sha_new_tree       = @client.create_tree(repo.full_name, 
                                   [ { :path => file_info[:path], 
                                       :mode => "100644", 
                                       :type => "blob", 
                                       :sha => blob_sha } ], 
                                   {:base_tree => sha_base_tree }).sha
commit_message      = "testing commits via Octokit!"
sha_new_commit      = @client.create_commit(repo.full_name, commit_message, sha_new_tree, sha_latest_commit).sha
updated_ref         = @client.update_ref(repo.full_name, ref, sha_new_commit)

pp "Content updated : #{file_info[:path]}"
pp new_content