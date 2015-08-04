class Account < ActiveRecord::Base
  self.table_name = "account"

  scope :include_customer_and_product_type, -> { includes(:customer, :product => :product_type) }

  belongs_to :customer, :foreign_key => :cust_id
  belongs_to :product, :foreign_key => :product_cd

  def as_json(options={})
    super options.merge(
      only: [
        :account_id,
        :avail_balance,
        :close_date,
        :last_activity_date,
        :open_date,
        :open_emp_id,
        :pending_balance,
        :status
      ],
      include: [
        :customer,
        product: {
          only: [
            :date_offered,
            :date_retired,
            :name,
            :product_cd
          ],
          include: :product_type
        }
      ]
    )
  end
end
