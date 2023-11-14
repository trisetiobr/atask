class User < ApplicationRecord
  has_secure_password

  has_one :subject, as: :subjectable, dependent: :destroy
  belongs_to :team, optional: true

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
end
