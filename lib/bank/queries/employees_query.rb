class EmployeesQuery
  def self.for_user(user)
    Employee.limit(10)
  end
end
