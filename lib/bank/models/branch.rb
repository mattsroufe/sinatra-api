class Branch < ActiveRecord::Base
  self.table_name = 'branch'
  scope :include_accounts, -> { includes(:accounts => [{customer: [:business, :individual]}, {:product => :product_type}]) }

  has_many :accounts, :foreign_key => :open_branch_id
end
