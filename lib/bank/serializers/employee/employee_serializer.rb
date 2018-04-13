class EmployeeSerializer
  include FastJsonapi::ObjectSerializer
  attributes :first_name, :last_name

  def self.build(user, options = {})
    if user.username == 'admin'
      AdminEmployeeSerializer.new(query(options), options)
    else
      new(query(options), options)
    end
  end

  def self.query(params)
    if params[:id]
      Employee.find(params[:id])
    else
      Employee.limit(10)
    end
  end
end
