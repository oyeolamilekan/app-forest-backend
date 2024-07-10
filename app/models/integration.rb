class Integration < ApplicationRecord
  include HasPublicId

  belongs_to :store
  enum provider: { stripe: "stripe", github: "github", gitlab: "gitlab" }
  validates_presence_of :provider, :key
  encrypts :key
  validates :endpoint_secret, presence: true, if: :endpoint_secret?
end
