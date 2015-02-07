class Account < ActiveRecord::Base
  self.table_name = "account"
  include Grape::Entity::DSL

  belongs_to :customer, :foreign_key => :cust_id

  entity do
    expose :account_id, as: :id, documentation: { type: "Integer", desc: "Account id", required: true }
    expose :product_cd, documentation: { type: "String", desc: "Product code" }
    expose :cust_id
    expose :open_date
    expose :close_date
    expose :last_activity_date
    expose :status, documentation: { type: "String", desc: "Account status" }
    expose :open_branch_id
    expose :open_emp_id
    expose :avail_balance
    expose :pending_balance
  end
end
