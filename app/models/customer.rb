# == Schema Information
#
# Table name: customers
#
#  id              :bigint           not null, primary key
#  email           :string
#  github_username :string
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  public_id       :string
#  store_id        :bigint           not null
#
# Indexes
#
#  index_customers_on_store_id  (store_id)
#
# Foreign Keys
#
#  fk_rails_...  (store_id => stores.id)
#
class Customer < ApplicationRecord
  include HasPublicId
  has_many :invoice
end
