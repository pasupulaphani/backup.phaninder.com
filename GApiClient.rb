require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'

class GApiClient

	attr_reader :client

	@client = @scope = @issuer = nil;

	def initialize(p12_key_file, passphrase, scope, issuer)

		# Initialize the client.
		@client = Google::APIClient.new(
		  :application_name => 'GApi',
		  :application_version => '0.1.0'
		)
		@scope = scope;
		@issuer = issuer;

		key = Google::APIClient::KeyUtils.load_from_pkcs12(p12_key_file, passphrase)
		authorize_clinet(key);
	end

	private
	def authorize_clinet(key)

		@client.authorization = Signet::OAuth2::Client.new(
		  :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
		  :audience => 'https://accounts.google.com/o/oauth2/token',
		  :scope => 'https://www.googleapis.com/auth/'+@scope,
		  :issuer => @issuer,
		  :signing_key => key)
		@client.authorization.fetch_access_token!

	end

end