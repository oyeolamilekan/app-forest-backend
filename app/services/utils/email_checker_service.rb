require 'net/http'
require 'json'

module Utils
  class EmailCheckerService < ApplicationService
    DISPOSABLE_DOMAINS_URL = 'https://raw.githubusercontent.com/disposable/disposable-email-domains/master/domains.json'

    attr_reader :email

    def initialize(email)
      @email = email
    end
    
    def call
      @disposable_domains = fetch_disposable_domains
      domain = extract_domain(email)
      @disposable_domains.include?(domain)
    end

    private

    def fetch_disposable_domains
      Rails.cache.fetch('disposable_email_domains', expires_in: 1.day) do
        uri = URI(DISPOSABLE_DOMAINS_URL)
        response = Net::HTTP.get(uri)
        JSON.parse(response)
      end
    rescue StandardError => e
      Rails.logger.error "Error fetching disposable domains: #{e.message}"
      []
    end

    def fetch_disposable_domains
      uri = URI(DISPOSABLE_DOMAINS_URL)
      response = Net::HTTP.get_response(uri)
      
      if response.is_a?(Net::HTTPSuccess)
        JSON.parse(response.body)
      else
        Rails.logger.error "Failed to fetch disposable domains. Status: #{response.code}"
      end
    rescue StandardError => e
      Rails.logger.error "Error fetching disposable domains: #{e.message}"
    end
  

    def extract_domain(email)
      email.split('@').last.downcase
    end
  end
end