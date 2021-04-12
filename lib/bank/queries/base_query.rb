class BaseQuery
  def initialize
    @joins = []
  end

  def self.model
    @model
  end

  def self.model=(klass)
    @model = klass
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
        "#{self.class.model.table_name}.#{attribute}"
      end
    end
    sql = self.class.model.select(select_sql).from(self.class.model.table_name).joins(joins.uniq.join(' ')).to_sql
    self.class.model.select('*').from("(#{sql}) s")
  end

  def all
    select(*self.class.base_attributes)
  end

  def join(join_sql, &block)
    @joins.push(join_sql)
    yield self if block_given?
  end

  def joins
    @joins
  end
end
