class DepartmentManagerRole < ApplicationRolde
  self.table_name = 'employee'

  has_many: :employees, -> { where(department_id: department_id) }
end

def index
  if current_user.department_manager?
    DepartmentManagerEmployeeSerializer
  else
    EmployeeSerializer
  end
end
