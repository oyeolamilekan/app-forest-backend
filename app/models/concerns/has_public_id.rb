module HasPublicId
  extend ActiveSupport::Concern

  included do
    before_create :generate_public_id
    validates :public_id, uniqueness: true
  end

  def generate_public_id
    self.public_id = Utils::GenerateRandomString.call(9)
  end
end