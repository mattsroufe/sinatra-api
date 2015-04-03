class Customer < ActiveRecord::Base
  self.table_name = 'customer'

  validates_presence_of :fed_id, :message => "id can't be blank"
  validates_presence_of :cust_type_cd

  has_many :accounts, :foreign_key => :cust_id
end
