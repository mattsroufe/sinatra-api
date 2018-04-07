class EmployeeSerializer
  def self.for_user(user)
    if user.username == 'admin'
      AdminSerializer
    else
      BaseSerializer
    end
  end

  class BaseSerializer
    include FastJsonapi::ObjectSerializer
    set_type :employee

    attributes :first_name, :last_name
  end

  class AdminSerializer
    include FastJsonapi::ObjectSerializer
    set_type :employee

    attributes :birth_date, :emp_no, :first_name, :gender, :hire_date, :last_name
  end
end
