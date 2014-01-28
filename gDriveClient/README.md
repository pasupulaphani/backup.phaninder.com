backup.phaninder.com
====================

##GDrive client and utils to backup my files


---------------------------------------------

Config is expected to be available under /etc/phaninder.com/backup.json

		{
			"dev": {
				"p12_key_file": "your google project privatekey.p12",
				"passphrase" : "service phrase",
				"scope" : "drive",
				"backup_folder" : "folder name on the drive",
				"issuer" :"project-service@developer.gserviceaccount.com"
			},
			"prod": {
		    // same goes here
			}
		}
