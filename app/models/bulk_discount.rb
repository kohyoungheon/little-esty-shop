class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :name, presence: true
  validates :quantity_threshold, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :percentage_discount, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
end