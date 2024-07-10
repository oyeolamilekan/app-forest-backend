module Utils
  class AddUserToRepo < ApplicationService
    attr_reader :repo, :username, :permission, :access_token

    def initialize(repo:, username:, permission:, access_token:)
      @repo = repo
      @username = username
      @permission = permission
      @access_token = access_token
    end

    def call
      begin
        client = Octokit::Client.new(access_token: access_token)
        client.add_collaborator(repo, username, permission: permission)
        [:success, "User #{username} added to repository #{repo} with #{permission} permission."]
      rescue => exception
        [:error, "User #{username} cannot be added to repository #{repo} with #{permission} permission."]
      end
    end
  end
end
