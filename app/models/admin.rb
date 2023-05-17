class Admin < ApplicationRecord
  include ActiveModel::Validations

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :cpf, presence: true
  validates_with CpfValidator
  validate :email_domain_is_valid

  has_many :created_lots, class_name: 'Lot', foreign_key: 'creator_id'
  has_many :published_lots, class_name: 'Lot', foreign_key: 'publisher_id'

  private
  def email_domain_is_valid
    admin_domain = 'leilaodogalpao.com.br'
    if self.email.present? && self.email.split('@')[1] != admin_domain
      self.errors.add(:email, 'inválido para administrador')
    end
  end
end
