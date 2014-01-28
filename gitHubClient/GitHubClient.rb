require 'octokit'

class GitHubClient

	attr_reader :client

	@client = nil;

	def initialize(login, token)

		# Initialize the client.
		@client = Octokit::Client.new :login => login, :token => token

	end
end