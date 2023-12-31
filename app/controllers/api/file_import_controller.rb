class Api::FileImportController < Api::ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_request!
  include FileImportHelper
  require 'csv'

  def import_file
    begin
      file = params[:csv_file]
      file_type = params[:file_type]
      if file.present? && file.original_filename.ends_with?(".csv")
        # Read the CSV file and process its data
        data = []
        not_created_entry = []
        CSV.foreach(file.path, headers: true) do |row|
          if file_type == 'apr'
            not_created_entry << create_reports(row)
          else
            not_created_entry << create_user(row)
          end
        end
        render json: { success: true, data: data, not_created_entry: not_created_entry.reject(&:empty?) }
      else
        render json: { success: false, error: 'Please select a valid CSV file.' }
      end
    rescue StandardError => e
      render json: { success: false, error: "An error occurred: #{e.message}" }
    end
  end

end




