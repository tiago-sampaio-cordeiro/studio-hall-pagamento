class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  enum :role, { employee: 0, admin: 1 }
  has_one :employee, dependent: :destroy

  validates :email_address, presence: true, uniqueness: true
  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
