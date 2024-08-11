# == Schema Information
#
# Table name: stores
#
#  id          :bigint           not null, primary key
#  description :text
#  logo        :string
#  logo_url    :string
#  name        :string
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  public_id   :string
#  user_id     :bigint           not null
#
# Indexes
#
#  index_stores_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class StoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
