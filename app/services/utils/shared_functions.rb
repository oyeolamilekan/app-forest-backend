require 'uri'

module Utils
  module SharedFunctions
    def self.add_subdomain(url, subdomain)
      uri = URI(url)
      uri.host = "#{subdomain}.#{uri.host}"
      uri.to_s
    end
  end
end