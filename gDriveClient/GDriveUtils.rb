require_relative './GDrive'

module GDriveUtils

	def get_backup_folder(client, name)
	  query = "title = '#{name}' \
	            and mimeType = 'application/vnd.google-apps.folder'"

	  backup_folder = GDrive::get_list(client, nil, query)

	  if backup_folder.length == 0
	    backup_folder = GDrive::create_folder(client, name, nil);
	  else
	    puts "########ERROR############ :: multiple backup \
	      folders found using latest one ATM" if backup_folder.length != 1
	    backup_folder = backup_folder[0]
	  end
	  backup_folder
	end

	def show_backup_list(client, config)
	  backup_folder = get_backup_folder(client, config['backup_folder'])

	  puts "Files Under #{config['backup_folder']} drive folder"
	  GDrive::get_list(client, backup_folder.id).each do |file|
	    puts file.title
	    puts "\t id:'#{file.id}'  created at:'#{file.createdDate}'"
	  end
	end

	def delete_all(client, parent_id=nil)
	  puts "Deleting files Under #{parent_id} drive folder"
	  GDrive::get_list(client, parent_id).each do |file|
	    puts file.title
	    puts "\t id:'#{file.id}'  created at:'#{file.createdDate}'"
	    GDrive::delete_file(client, file.id)
	    puts "#### Deleted ####"
	  end
	end

	def download_all(client, download_to, parent_id=nil)
	  puts "downloading files Under #{parent_id} drive folder to local #{download_to}"
	  GDrive::get_list(client, parent_id).each do |file|
	    puts file.title
	    puts "\t id:'#{file.id}'  created at:'#{file.createdDate}'"
	    GDrive::download_file(client, file, download_to)
	    puts "#### Done ####"
	  end
	end

	def download_backup_files(client, config, download_to)
		backup_folder = get_backup_folder(client, config['backup_folder'])
		download_all(client, download_to, backup_folder.id)
	end
end