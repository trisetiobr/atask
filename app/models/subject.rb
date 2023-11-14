class Subject < ApplicationRecord
  belongs_to :subjectable, polymorphic: true
  has_many :payment_transactions
end
