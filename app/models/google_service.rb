	class GoogleService

	attr_accessor :client, :files, :session, :drive
		#need to tidy up spec
		def initialize(client, authorisation)
			@client = client
			@authorization = authorisation
			@files = nil
			@session = nil
			@drive = discovered_api
			@plus = discovered_gplus_api
		end
		#to add rspec test with fixture
		def parse_access_codes(request)
			responseData = request.body.read
        	@authorization.code = responseData.split(',')[0]
        	@client.authorization = @authorization
        	id_token = responseData.split(',')[1]
        	encoded_json_body = id_token.split('.')[1]
        	encoded_json_body += (['='] * (encoded_json_body.length % 4)).join('')
        	json_body = Base64.decode64(encoded_json_body)
        	body = JSON.parse(json_body)
        	set_session({body: body, response: responseData})        	
		end

		def set_session google_response
			@session = {}
			gplus_id = google_response[:body]['sub']
    		email = google_response[:body]['email']
    		@session[:token] = google_response[:response].split(',')[2]
    		set_auth(@session[:token])
    		@session[:uid] = gplus_id
    		@session[:email] = email
    		execute_friend_list #Cache friend list
		end

		def set_auth token
			@client.authorization.access_token = token
		end

		def check_user_session token
			set_auth(token)
			result = @client.execute(
	          :api_method => @plus.people.get,
	          :parameters => {'userId' => 'me'}
	        )
			result
		end

		# def set_files files
		# 	@files = files
		# end

		# def get_user_files token
		#    set_auth(token)
		#    response = @client.execute(:api_method => @drive.files.list )
  #   	   @files = JSON.parse(response.data.to_json)
		# end

		def disconnect_user token
			revokePath = 'https://accounts.google.com/o/oauth2/revoke?token=' + token
    		# Sending the revocation request and returning the result.
    		uri = URI.parse(revokePath)
    		request = Net::HTTP.new(uri.host, uri.port)
    		request.use_ssl = true
    		request.get(uri.request_uri).code
		end

		def upload_ledger_csv user_tag, token
		   #used for trns but same as tb_csv below.. :(
		   set_auth(token)
	       mime_type = 'application/vnd.google-apps.spreadsheet'
	       media = Google::APIClient::UploadIO.new("#{Rails.root}/files/new-file.csv", 'text/csv')
	       file = @drive.files.insert.request_schema.new({
	        'title' => "[monea][#{user_tag}]." + "export( #{Time.now.strftime('%d %B %y')} )" ,
	        'mimeType' => mime_type})
	       execute_upload(file, media)
         #add reponse flash front end
		end

		def upload_new_file_csv user_tag, token
			set_auth(token)
			mime_type = 'application/vnd.google-apps.spreadsheet'
			media = Google::APIClient::UploadIO.new("#{Rails.root}/files/new-file.csv", 'text/csv')
			
			file = @drive.files.insert.request_schema.new({
	        'title' => "[monea][#{user_tag}]." + "export( #{Time.now.strftime('%d %B %y')} )" ,
	        'mimeType' => mime_type})

	       	execute_upload(file, media)
		end

		def create_new_document
			  @drive = discovered_api
			  mime_type = 'application/vnd.google-apps.document'
			  file = @drive.files.insert.request_schema.new(title: 'Via monea.build', mime_type: mime_type)
			  media = Google::APIClient::UploadIO.new("#{Rails.root}/files/blank.csv", 'text/csv')
			  response =  execute_upload(file, media)
			  response.data.alternateLink rescue ""
		end

		def create_new_spreadsheet(parent_id = nil)
			  @drive = discovered_api
			  mime_type = 'application/vnd.google-apps.spreadsheet'
			  file = @drive.files.insert.request_schema.new(title: 'Via monea.build', mime_type: mime_type)
			  file.parents = [{'id' => parent_id}] if parent_id
			  media = Google::APIClient::UploadIO.new("#{Rails.root}/files/blank.csv", 'text/csv')
			  response =  execute_upload(file, media)
			  response.data.alternateLink rescue ""
		end

		def create_user_invoice_folder salesLedgerName
			@drive = discovered_api
			file = @drive.files.insert.request_schema.new({
	    		'title' => '[sales.folder][' + salesLedgerName +'][monea]',
	    		'description' => 'monea.invoices',
	    		'mimeType' => 'application/vnd.google-apps.folder'
  			})
		    response = @client.execute(:api_method => @drive.files.insert, :body_object => file)
			response.data.alternateLink rescue ""
		end 

		def create_user_report_folder reportName
			@drive = discovered_api
			file = @drive.files.insert.request_schema.new({
	    		'title' => '[report.folder][' + reportName +'][monea]',
	    		'description' => 'monea.reports',
	    		'mimeType' => 'application/vnd.google-apps.folder'
  			})
		    response = @client.execute(:api_method => @drive.files.insert, :body_object => file)

			response.data.alternateLink rescue ''
			if response.data['error']
				response.data['error']['message']
			else
				response.data.alternateLink rescue ""
			end
		end

		# USED BY SALES INVOICING FUNC and NOTES fileLINK
		def copy_file(source_file_id, title, parent_folder_id = nil, backup_title=nil )
			if backup_title
				 $title = "[#{backup_title}][#{title}][monea]" 
			else
				 $title = "[#{title}][monea]" 
			end
			file = @drive.files.copy.request_schema.new({
			  'title' => $title
			})
			file.parents = [{'id' => parent_folder_id}] if parent_folder_id
			result = @client.execute(
			  :api_method => @drive.files.copy,
			  :body_object => file,
			  :parameters => { 'fileId' => source_file_id })
			if result.data['error']
				result.data['error']['message']
			else
				result.data.alternateLink rescue ""
			end
		end

		def rename_inv_file_paid(file_id, token)
			  set_auth(token)
			  $result = @client.execute(
			    :api_method => drive.files.get,
			    :parameters => { 'fileId' => file_id })
			  if $result.status == 200
			  	 file = $result.data
			  	 new_title = "[PAID]" + file.title
			  	 $result = client.execute(
	    			:api_method => drive.files.patch,
	    			:body_object => { "title" => new_title, "description" => "Marked Paid #{Time.now.strftime('%d %B %y')}" },
	    			:parameters => { 'fileId' => file_id })
			  	 if $result.status == 200
				    return $result.data
				 end
			  else
				  puts "An error occurred: #{$result.data['error']['message']}"
				  return nil
			  end
		end

		def execute_friend_list
			friend_list = @client.execute(@plus.people.list,
	                                :collection => 'visible',
 	                                :userId => 'me')
			Rails.cache.write("FRIENDS_LIST", friend_list.data.items)
		end

	private

		def discovered_api
		   @client.discovered_api('drive', 'v2')
		end

		def execute_upload file, media
		   @client.execute(
		        :api_method => @drive.files.insert,
		        :body_object => file,
		        :media => media,
		        :parameters => {
		          'convert' => 'true',
		          'uploadType' => 'multipart',
		          'alt' => 'json'})
		end

		def discovered_gplus_api
			@client.discovered_api('plus', 'v1')
		end
end
