class Product < ActiveRecord::Base
  self.table_name = "product"

  belongs_to :product_type, :foreign_key => :product_type_cd
end
