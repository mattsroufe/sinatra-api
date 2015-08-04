class Individual < ActiveRecord::Base
  self.table_name = 'individual'

  has_many :customers, as: :owner, foreign_key: :cust_id
end
