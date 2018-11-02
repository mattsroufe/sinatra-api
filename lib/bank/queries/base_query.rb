class BaseQuery
  def initialize
    @joins = []
  end

  def self.table_name
    @name
  end

  def self.model
    @model
  end

  def self.model=(klass)
    @model = klass
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
        "#{self.class.table_name}.#{attribute}"
      end
    end
    sql = self.class.model.select(select_sql).from(self.class.table_name).joins(joins.uniq.join(' ')).to_sql
    self.class.model.select('*').from("(#{sql}) s")
  end

  def all
    select(*self.class.base_attributes)
  end

  def join(join_sql)
    @joins.push("LEFT JOIN #{join_sql}")
  end

  def joins
    @joins
  end
end

# describe CrewQuerySpec
#   it "works" do
#     expect(CrewQuery.new(current_user).select(:first_name, :last_name, :full_name).limit(10)).to eq(

#     )
#   end
# end