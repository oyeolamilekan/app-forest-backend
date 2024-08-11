# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :text
#  first_name      :string
#  last_name       :text
#  password        :text
#  password_digest :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  public_id       :text
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
