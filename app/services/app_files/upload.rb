module AppFiles
  class Upload < ApplicationService
    attr_reader :file
    
    def initialize(file:)
      @file = file
    end

    def call
      upload_file = Cloudinary::Uploader.upload(file)
      return [:success, upload_file]
    rescue => e
      return [:error, "Error in uploading file"]
    end
  end
end
