class Item < ApplicationRecord
  validates :name, :description, :product_category, presence: true

  before_validation :generate_code

  has_one_attached :picture do |att|
    att.variant :thumb, resize_to_limit: [300, 300]
  end

  private
  def generate_code
    self.code = SecureRandom.alphanumeric(10).upcase
  end
end
