class Business < ActiveRecord::Base
  self.table_name = 'business'

  has_many :customers, as: :owner, foreign_key: :cust_id
end
