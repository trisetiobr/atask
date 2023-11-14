class PaymentTransaction < ApplicationRecord
  belongs_to :subject

  validates :amount, numericality: { greater_than_or_equal_to: 0 }
end
