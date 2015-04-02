class Account < ActiveRecord::Base
  self.table_name = "account"

  belongs_to :customer, :foreign_key => :cust_id
end
