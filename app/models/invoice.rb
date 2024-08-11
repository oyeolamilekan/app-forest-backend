# == Schema Information
#
# Table name: invoices
#
#  id          :bigint           not null, primary key
#  date        :date
#  description :string
#  quantity    :integer
#  total       :decimal(, )
#  unit_price  :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :bigint           not null
#  product_id  :bigint           not null
#  public_id   :string
#  store_id    :bigint           not null
#
# Indexes
#
#  index_invoices_on_customer_id  (customer_id)
#  index_invoices_on_product_id   (product_id)
#  index_invoices_on_store_id     (store_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (store_id => stores.id)
#
class Invoice < ApplicationRecord
  include HasPublicId

  belongs_to :customer
  belongs_to :store
  belongs_to :product

  before_save :calculate_total
  after_create :send_invoice

  private

  def calculate_total
    self.total = quantity * unit_price
  end

  def send_invoice
    InvoiceMailer.send_invoice(self).deliver_later
  end
end

