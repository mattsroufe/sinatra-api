class Employee < ActiveRecord::Base
  self.table_name = "employee"

  belongs_to :current_dept_emp

  scope :male, -> { where(gender: 'M') }
end
