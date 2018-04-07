class EmployeesSerializer
  def self.build(user, options = {})
    if user.username == 'admin'
      AdminEmployeeSerializer.new(employees, options)
    else
      EmployeeSerializer.new(employees, options)
    end
  end

  def self.employees
    Employee.limit(10)
  end
end
