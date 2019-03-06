class User < ApplicationRecord
  has_secure_password

  has_many :devices

  validates :email, uniqueness: true, presence: true
end
