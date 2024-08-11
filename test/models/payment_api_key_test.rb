# == Schema Information
#
# Table name: payment_api_keys
#
#  id          :bigint           not null, primary key
#  auth_key    :string
#  platform    :string
#  webhook_key :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  public_id   :string
#  store_id    :bigint           not null
#
# Indexes
#
#  index_payment_api_keys_on_store_id  (store_id)
#
# Foreign Keys
#
#  fk_rails_...  (store_id => stores.id)
#
require "test_helper"

class PaymentApiKeyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
