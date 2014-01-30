module GitHub

	def get_file_info(client, repo, path, branch)
		begin
			file_info = client.contents(repo.full_name, :path => path, :branch => branch).to_hash
			rescue Octokit::NotFound => e  
			puts "404 : #{file} not found in #{repo.full_name}"
			puts e.message
			# you can call create method and then exit
			return false
		rescue Exception => e
			puts "what have you done; you are screwed"
			puts "An error of type #{e.class} happened, message is #{e.message}"
			return false
		end
		return file_info
	end

	def update_file(client, repo, ref, path, content)

		################### Step 1 ###################
		# GET /repos/:user/:repo/git/refs/heads/master
		# Store the SHA for the latest commit (SHA-LATEST-COMMIT)
		sha_latest_commit  = client.ref(repo.full_name, ref).object.sha


		################### Step 2 ###################
		# GET /repos/:user/:repo/git/commits/SHA-LATEST-COMMIT
		# Store the SHA for the tree (SHA-BASE-TREE)
		sha_base_tree      = client.commit(repo.full_name, sha_latest_commit).commit.tree.sha


		################### Step 3 ###################
		# POST /repos/:user/:repo/git/trees/ while authenticated
		# Set base_tree to be SHA-BASE-TREE
		# Set path to be the full path of the file you are creating or editing
		# Set content to be the full contents of the file
		# From the response, get the top-level SHA (SHA-NEW-TREE)
		blob_sha           = client.create_blob(repo.full_name, Base64.encode64(content), "base64")

		sha_new_tree       = client.create_tree(repo.full_name, 
		                                   [ { :path => path, 
		                                       :mode => "100644", 
		                                       :type => "blob", 
		                                       :sha => blob_sha } ], 
		                                   {:base_tree => sha_base_tree }).sha


		################### Step 4 ###################
		# POST /repos/:user/:repo/git/commits while authenticated
		# Set parents to be an array containing SHA-LATEST-COMMIT
		# Set tree to be SHA-NEW-TREE
		# From the response, get the top-level SHA (SHA-NEW-COMMIT)
		commit_message      = "testing commits via Octokit!"
		sha_new_commit      = client.create_commit(repo.full_name, commit_message, sha_new_tree, sha_latest_commit).sha


		################### Step 5 ###################
		# POST /repos/:user/:repo/git/refs/head/master while authenticated
		# Set sha to be SHA-NEW-COMMIT
		# You may need to set force to be true
		updated_ref         = client.update_ref(repo.full_name, ref, sha_new_commit)
		
	end
end