class EmployeeSerializer
  include FastJsonapi::ObjectSerializer
  attributes :first_name, :last_name

  def self.for_user(user)
    if user.username == 'admin'
      AdminEmployeeSerializer
    else
      self
    end
  end
end
