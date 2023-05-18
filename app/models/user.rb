class User < ApplicationRecord
  include ActiveModel::Validations

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :cpf, presence: true
  validates_with CpfValidator
  validate :email_is_used_by_admin
  validate :cpf_is_used_by_admin

  has_many :bids

  private
  def email_is_used_by_admin
    if self.email.present? && Admin.exists?(email: self.email)
      self.errors.add(:email, 'já está registrado por um administrador')
    end
  end

  def cpf_is_used_by_admin
    if self.cpf.present? && Admin.exists?(cpf: self.cpf)
      self.errors.add(:cpf, 'já está registrado por um administrador')
    end
  end
end
