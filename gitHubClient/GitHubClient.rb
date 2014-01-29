require 'octokit'

class GitHubClient

	attr_reader :client

	@client = nil;

	def initialize(login, token)

		# Initialize the client.
		@client = Octokit::Client.new :login => login, :access_token => token

	end
end