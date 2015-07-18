class Account < ActiveRecord::Base
  self.table_name = "account"

  belongs_to :customer, :foreign_key => :cust_id
  belongs_to :product, :foreign_key => :product_cd
end
