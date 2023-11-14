class Stock < ApplicationRecord
  has_one :subject, as: :subjectable
end
