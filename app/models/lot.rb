class Lot < ApplicationRecord
  validates :code, presence: true
  validate :code_is_valid

  belongs_to :creator, class_name: 'Admin'
  belongs_to :publisher, class_name: 'Admin', optional: true

  has_many :items
  has_many :bids

  enum status: { waiting_approval: 0, published: 1, closed: 2, canceled: 3}

  private

  def code_is_valid
    code_regex = /^[A-Za-z]{3}\d{6}$/
    if !code_regex.match? self.code
      self.errors.add(:code, 'inválido. formato correto: (3 letra + 6 números)')
    end
  end
end
