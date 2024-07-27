class Integration < ApplicationRecord
  include HasPublicId

  GITHUB = "github".freeze
  GITLAB = "gitlab".freeze
  STRIPE = "stripe".freeze

  PULL_PERMISSION = "pull"

  belongs_to :store
  enum provider: { stripe: "stripe", github: "github", gitlab: "gitlab" }
  validates_presence_of :provider, :key
  encrypts :key
  validates :endpoint_secret, presence: true, if: :endpoint_secret?
end
