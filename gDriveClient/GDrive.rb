module GDrive

	def self.insert_file(client, title, description, mime_type, file_name, parent_id)
	  drive = client.discovered_api('drive', 'v2')
	  file = drive.files.insert.request_schema.new({
	    'title' => title,
	    'description' => description,
	    'mimeType' => mime_type
	  })

	  # Set the parent folder.
	  if parent_id
	    file.parents = [{'id' => parent_id}]
	  end

	  media = Google::APIClient::UploadIO.new(file_name, mime_type)
	  result = client.execute(
	    :api_method => drive.files.insert,
	    :body_object => file,
	    :media => media,
	    :parameters => {
	      'uploadType' => 'multipart',
	      'alt' => 'json'})

	  if result.status == 200
	    return result.data
	  else
	    puts "An error occurred: #{result.data['error']['message']}"
	    return nil
	  end
	end

	# A folder is a file with the MIME type application/vnd.google-apps.folder and with no extension.
	# Folders are identified by the parents key in the state parameter.
	def self.create_folder(client, name, parent_id)
	  drive = client.discovered_api('drive', 'v2')
	  file = drive.files.insert.request_schema.new({
	    'title' => name,
	    'description' => '',
	    'mimeType' => "application/vnd.google-apps.folder"
	  })

	  # Set the parent folder.
	  if parent_id
	    file.parents = [{'id' => parent_id}]
	  end

	  result = client.execute(
	    :api_method => drive.files.insert,
	    :body_object => file)

	  if result.status == 200
	    return result.data
	  else
	    puts "An error occurred: #{result.data['error']['message']}"
	    return nil
	  end
	end

	def self.get_list(client, parent_id=nil, q=nil)
	  drive = client.discovered_api('drive', 'v2')
	  result = Array.new
	  page_token = nil
	  begin
	    parameters = {}

	    if page_token.to_s != ''
	      parameters['pageToken'] = page_token
	    end

	    if q
	    	parameters['q'] = q
			end

	    if parent_id
	    	if !parameters['q']
	    		parameters['q'] = parameters['q'] || ''
	    	else
	    		parameters['q'] = parameters['q'] + 'and'
	    	end
	      parameters['q'] = parameters['q'] + " '#{parent_id}' in parents"
	    end

	    api_result = client.execute(
	      :api_method => drive.files.list,
	      :parameters => parameters)

	    if api_result.status == 200
	      files = api_result.data
	      result.concat(files.items)
	      page_token = files.next_page_token
	    else
	      puts "An error occurred: #{api_result.data['error']['message']}"
	      page_token = nil
	    end

	  end while page_token.to_s != ''
	  result
	end

	##
	# Download a file's content
	#
	# @param [Google::APIClient] client
	#   Authorized client instance
	# @param [Google::APIClient::Schema::Drive::V2::File]
	#   Drive File instance
	# @param [String]
	#   Location download to
	# @return
	#   File's content if successful, nil otherwise
	def self.get_file_content(client, file)
	  if file.download_url
	    result = client.execute(:uri => file.download_url)
	    if result.status == 200
	      return result.body
	    else
	      puts "An error occurred: #{result.data['error']['message']}"
	      return nil
	    end
	  else
	    # The file doesn't have any content stored on Drive.
	    return nil
	  end
	end

	def self.download_file(client, file, download_loc)
	  content = get_file_content(client, file);
	  if content
	    File.open(download_loc+'/'+file.id+'_'+file.title, 'w') do |file| 
	      file.write(content)
	    end
	    puts "The file #{file.title} contents are written to #{download_loc}"
	  else
	    puts "The file #{file.title} doesn't have any content stored on Drive."
	  end
	end

	##
	# Permanently delete a file, skipping the trash
	#
	# @param [Google::APIClient] client
	#   Authorized client instance
	# @param [String] file_id
	#   ID of the file to delete
	# @return nil
	############for some reason this throws an error but files will be removed
	def self.delete_file(client, file_id)
	  drive = client.discovered_api('drive', 'v2')
	  result = client.execute(
	    :api_method => drive.files.delete,
	    :parameters => { 'fileId' => file_id })
	  if result.status != 200
	    puts "An error occurred: #{result.data}"
	  end
	end
end