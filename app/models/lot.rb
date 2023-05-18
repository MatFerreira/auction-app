class Lot < ApplicationRecord
  validates :code, presence: true

  belongs_to :creator, class_name: 'Admin'
  belongs_to :publisher, class_name: 'Admin', optional: true

  has_many :items
  has_many :bids

  enum status: { waiting_approval: 0, published: 1 }
end
