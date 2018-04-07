class EmployeeSerializer
  include FastJsonapi::ObjectSerializer
  attributes :first_name, :last_name

  def self.for_user(user)
    if user.username == 'admin'
      AdminSerializer
    else
      self
    end
  end

  class AdminSerializer
    include FastJsonapi::ObjectSerializer
    set_type :employee

    attributes :birth_date, :emp_no, :first_name, :gender, :hire_date, :last_name
  end
end
