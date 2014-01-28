backup.phaninder.com 
====================
> (still trying to move to public repo)

> Please note that the modules and code in this repo are only samples (but working copies). Actual modules are in private repos.

## GDrive client and utils to backup my files (old)

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

--------
## GitHub client and utils to backup my files (new and currently used)

> Authentication and authorization
* Personal access token

> GitHub::APIClient
* octokit

---------------------------------------------

Configuration

		{
			"username": "your github username",
			"token": "your personal access token",
			"backup": {
				"repo": "repository name",
				"branch": "master",
				"folder": "folder path"
			}
		}

--------
