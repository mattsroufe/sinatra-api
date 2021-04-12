require_relative './base_query'
require_relative './../models/employee'

class EmployeesQuery < BaseQuery
  self.model = Employee
  
  attributes :id, :birth_date, :first_name, :last_name, :gender, :hire_date

  def full_name
    "CONCAT(employee.first_name, ' ', employee.last_name)"
  end

  def current_department
    # join 'JOIN current_dept_emp ON employees.emp_no = current_dept_emp.emp_no'
    # join 'JOIN departments ON current_dept_emp.dept_no = departments.dept_no'
    "'departments.dept_name'"
  end

  def current_department_name
    join 'JOIN department_employee ON department_employee.employee_id = employee.id AND department_employee.to_date > CURRENT_DATE'
    join 'JOIN department ON department.id = department_employee.department_id'
    'department.dept_name'
  end

  def current_salary
    # join 'JOIN salaries ON employees.emp_no = salaries.emp_no AND salaries.to_date > CURDATE()'
    "'salary'"
  end
end

