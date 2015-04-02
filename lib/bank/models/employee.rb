class Employee < ActiveRecord::Base
  self.table_name = 'employee'

  validates_presence_of :emp_id
end
