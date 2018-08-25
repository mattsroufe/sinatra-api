class BaseQuery
  def self.table_name
    @name
  end

  def self.model
    @model
  end

  def self.model=(name)
    @model = name
  end

  def self.table_name=(name)
    @name = name
  end

  def self.base_attributes
    @attributes
  end

  def self.attributes(*attributes)
    @attributes = attributes
  end

  def select(*attributes)
    select_sql = attributes.map do |attribute|
      if public_methods.include? attribute
        "#{send(attribute)} AS #{attribute}"
      else
        attribute
      end
    end
    self.class.model.constantize.select(select_sql).from(self.class.table_name)
  end

  def all
    select(*self.class.base_attributes)
  end

  def join(hash)
    @joins = hash
  end
end

class EmployeesQuery < BaseQuery
  self.model = 'Employee'
  self.table_name = 'employees'
  
  attributes :emp_no, :birth_date, :first_name, :last_name, :gender, :hire_date

  def full_name
    "CONCAT(first_name, ' ', last_name)"
  end

  # def current_department
  #   join :current_dept_emp, on: 'employees.emp_no = current_dep_emp.emp_no'
  #   join :departments, on: 'current_dep_emp.dept_no = department.dept_no'
  #   "departments.dept_name"
  # end
end
