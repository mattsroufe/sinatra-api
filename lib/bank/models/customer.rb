class Customer < ActiveRecord::Base
  self.table_name = 'customer'

  has_many :accounts, :foreign_key => :cust_id
  belongs_to :business, :foreign_key => :cust_id
  belongs_to :individual, :foreign_key => :cust_id

  validates_presence_of :fed_id, :message => "id can't be blank"
  validates_presence_of :cust_type_cd
  validates_inclusion_of :cust_type_cd, :in => %w[B I]

end
