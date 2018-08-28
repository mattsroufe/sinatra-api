class Employee < ActiveRecord::Base
  belongs_to :current_dept_emp

  scope :male, -> { where(gender: 'M') }
end
