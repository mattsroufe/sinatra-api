require_relative './base_query'
require_relative './../models/employee'

class EmployeesQuery < BaseQuery
  self.model = Employee
  
  attributes :id, :birth_date, :first_name, :last_name, :gender, :hire_date

  def full_name
    "CONCAT(employee.first_name, ' ', employee.last_name)"
  end

  def current_department_name
    join 'JOIN department_employee ON department_employee.employee_id = employee.id AND department_employee.to_date > CURRENT_DATE' do
      join 'JOIN department ON department.id = department_employee.department_id' do
        'department.dept_name'
      end
    end
  end

  def current_manager_name
    join 'JOIN department_employee ON department_employee.employee_id = employee.id AND department_employee.to_date > CURRENT_DATE' do
      join 'JOIN department_manager ON department_manager.department_id = department.id' do
        join 'JOIN employee e ON employee.id = department_employee.employee_id AND department_manager.to_date > CURRENT_DATE' do
          "CONCAT(e.first_name, ' ', e.last_name)"
        end
      end
    end
  end

  def current_salary
    # join 'JOIN salaries ON employees.emp_no = salaries.emp_no AND salaries.to_date > CURDATE()'
    "'salary'"
  end
end

