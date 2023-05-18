class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :lot

  validates :value, presence: true
  validate :bid_value_is_valid
  validate :lot_is_ongoing

  private
  def bid_value_is_valid
    highest_bid = Bid.where(lot_id: self.lot_id).order(value: :desc).first
    if highest_bid.nil? && self.value < self.lot.minimum_bid
      self.errors.add(:value, 'inferior ao lance mínimo')
    elsif !highest_bid.nil? && self.value < (highest_bid.value + self.lot.minimum_bid_increment)
      self.errors.add(:value, 'inferior a (maior lance + diferença mínima entre lances)')
    end
  end

  def lot_is_ongoing
    if Date.today < self.lot.initial_date
      self.errors.add(:lot_id, 'não iniciado')
    elsif Date.today > self.lot.limit_date
      self.errors.add(:lot_id, 'vencido')
    end
  end
end
