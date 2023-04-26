class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, -> { distinct }, through: :invoice_items
  has_many :merchants, -> { distinct }, through: :items

  validates :status, presence: true

  enum status: ["In Progress", "Completed", "Cancelled"]

  def self.find_and_sort_incomplete_invoices
    joins(:invoice_items).where('invoice_items.status != ?', '2').group(:id).order(:created_at)
  end

  def self.find_with_successful_transactions
    joins(:transactions).where('transactions.result = true').distinct
  end

  def self.order_by_id
    order(:id)
  end

  def customer_name
    customer.first_name + " " + customer.last_name
  end

  def total_revenue
    invoice_items.sum('unit_price * quantity')
  end

  def total_discounted_revenue(merchant)
    invoice_items
    .joins(item: { merchant: :bulk_discounts })
    .where("bulk_discounts.merchant_id = ? AND invoice_items.invoice_id = ?", merchant.id, self.id)
    .group("bulk_discounts.id")
    .select("SUM(CASE WHEN invoice_items.quantity >= bulk_discounts.quantity_threshold 
                        THEN invoice_items.quantity * invoice_items.unit_price * (1 - (bulk_discounts.percentage_discount/100)) 
                        ELSE invoice_items.quantity * invoice_items.unit_price 
                      END) AS discounted_revenue")
    .order("discounted_revenue ASC")
    .first
    .discounted_revenue
  end

  def admin_discounted_revenue
    invoice_items
    .joins(item: { merchant: :bulk_discounts })
    .where("invoice_items.invoice_id = ?",self.id)
    .group("bulk_discounts.id")
    .select("SUM(CASE WHEN invoice_items.quantity >= bulk_discounts.quantity_threshold 
                      THEN invoice_items.quantity * invoice_items.unit_price * (1 - (bulk_discounts.percentage_discount/100)) 
                      ELSE invoice_items.quantity * invoice_items.unit_price 
                      END) AS discounted_revenue")
    .order("discounted_revenue ASC")
    .first
    .discounted_revenue
  end
  
end
