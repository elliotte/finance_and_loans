class FilesController < ApplicationController

  skip_before_filter :verify_token
  
#   def index
#     @files = google_service.get_user_files(session[:token])
#     parse_for_index
#   end

#   def delete_file
#     result = $client.execute(
#       :api_method => @drive.files.delete,
#       :parameters => { 'fileId' => params['fileid'] })
#     if result.status != 200
#       render json: 'Files deleted.'.to_json
#     end
#   end

#   def new_document
#     @url = google_service.create_new_document
#     respond_to do |format|
#       format.js{ render 'new_file' }
#     end
#   end

#   def new_spreadsheet
#     @url = google_service.create_new_spreadsheet
#     respond_to do |format|
#       format.js{ render 'new_file' }
#     end
#   end

# private

#   def parse_for_index
#     cleanse_files rescue nil
#     block_for_index rescue nil
#   end

#   def cleanse_files
#     @files['items'].delete_if { |file| file['labels']['trashed'] == true }
#     #@files['items'].sort_by! { |f| DateTime.parse(f['modifiedByMeDate'] || Time.now-1.year) }
#   end

#   def block_for_slider
#     @blocks_for_slider = []
#     while  @files['items'].count > 0
#       @blocks_for_slider.concat([@files['items'].pop(6)])
#     end
#     return @blocks_for_slider
#   end

#   def block_for_index
#     @blocks_for_index = []
#     while  @files['items'].count > 0
#       @blocks_for_index.concat([@files['items'].pop(4)])
#     end
#     return @blocks_for_index
#   end

end
