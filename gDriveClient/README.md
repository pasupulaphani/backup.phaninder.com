backup.phaninder.com
====================

##GDrive client and utils to backup my files

> Authentication and authorization
* OAuth2

> Google::APIClient
* drive api version V2

> google-api-client modules
* google/api_client
* google/api_client/client_secrets
* google/api_client/auth/installed_app

> Supports multipart media upload

---------------------------------------------

Configuration

		{
			"p12_key_file": "your google project privatekey.p12",
			"passphrase" : "service phrase",
			"scope" : "drive",
			"backup_folder" : "folder name on the drive",
			"issuer" :"project-service@developer.gserviceaccount.com"
		}
