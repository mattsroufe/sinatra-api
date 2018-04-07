class AdminEmployeeSerializer
  include FastJsonapi::ObjectSerializer
  set_type :employee

  attributes :birth_date, :emp_no, :first_name, :gender, :hire_date, :last_name
end
