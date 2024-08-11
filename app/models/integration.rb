# == Schema Information
#
# Table name: integrations
#
#  id              :bigint           not null, primary key
#  endpoint_secret :string
#  key             :string
#  provider        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  public_id       :string
#  store_id        :bigint           not null
#
# Indexes
#
#  index_integrations_on_store_id  (store_id)
#
# Foreign Keys
#
#  fk_rails_...  (store_id => stores.id)
#
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
