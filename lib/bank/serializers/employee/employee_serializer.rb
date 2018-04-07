class EmployeeSerializer
  include FastJsonapi::ObjectSerializer
  attributes :first_name, :last_name

  def self.build(user, options = {})
    employee = Employee.find(options[:id])
    if user.username == 'admin'
      AdminEmployeeSerializer.new(employee, options)
    else
      new(employee, options)
    end
  end
end
