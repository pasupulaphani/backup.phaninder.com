require 'json'
require 'pp'
require 'base64'

require_relative "./GitHubClient"
require_relative "./GitHub"

include GitHub

env         = ENV['BACKUP_ENV'] || 'prod'
config_file = "../config/#{env}.backup.json"
config      = JSON.parse(IO.read(config_file))['github'];

@client = GitHubClient.new(config["username"], config["token"]).client

repo   = @client.repo config["backup"]["repo"]
branch = config["backup"]["branch"]
ref    = "heads/"+branch
file   = "#{config["backup"]["folder"]}/api_test.json"

file_info = get_file_info(@client, repo, file, branch)

pp "Content before commit : #{file_info[:path]}"
pp Base64.decode64(file_info[:content]).delete("\n")

new_content = "test5"
pp update_file(@client, repo, ref, file_info[:path], new_content)

pp "Content updated : #{file_info[:path]}"
