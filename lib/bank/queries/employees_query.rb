require_relative './base_query'
require_relative './../models/employee'

class EmployeesQuery < BaseQuery
  self.model = Employee
  self.table_name = 'employees'
  
  attributes :emp_no, :birth_date, :first_name, :last_name, :gender, :hire_date

  def full_name
    "CONCAT(employees.first_name, ' ', employees.last_name)"
  end

  def current_department
    join 'JOIN current_dept_emp ON employees.emp_no = current_dept_emp.emp_no'
    join 'JOIN departments ON current_dept_emp.dept_no = departments.dept_no'
    "departments.dept_name"
  end

  def current_department_manager
    join 'JOIN current_dept_emp ON employees.emp_no = current_dept_emp.emp_no'
    join 'JOIN departments ON current_dept_emp.dept_no = departments.dept_no'
    join 'JOIN dept_manager ON departments.dept_no = dept_manager.dept_no AND dept_manager.to_date > CURDATE()'
    join 'JOIN employees e ON dept_manager.emp_no = e.emp_no'
    "CONCAT(e.first_name, ' ', e.last_name)"
  end

  def current_salary
    join 'JOIN salaries ON employees.emp_no = salaries.emp_no AND salaries.to_date > CURDATE()'
    'salary'
  end
end

__END__

class EmployeesQuery < BaseQuery
  self.model = Employee
  self.table_name = 'employees'
  
  select :emp_no, :birth_date, :first_name, :last_name, :gender, :hire_date
  select "CONCAT(employees.first_name, ' ', employees.last_name)", as: :full_name

  join 'JOIN current_dept_emp ON employees.emp_no = current_dept_emp.emp_no' do
    join 'JOIN departments ON current_dept_emp.dept_no = departments.dept_no' do
      select "departments.dept_name", as: :current_department
      join 'JOIN dept_manager ON departments.dept_no = dept_manager.dept_no AND dept_manager.to_date > CURDATE()' do
        join 'JOIN employees e ON dept_manager.emp_no = e.emp_no' do
          select "CONCAT(e.first_name, ' ', e.last_name)", as: :current_department_manager
        end
      end
    end
  end

  join 'JOIN salaries ON employees.emp_no = salaries.emp_no AND salaries.to_date > CURDATE()' do
    select 'salary', as: :current_salary
  end
end
