class PaymentApiKey < ApplicationRecord
  include HasPublicId

  belongs_to :store
  validates_presence_of :platform, :auth_key, :webhook_key
end
