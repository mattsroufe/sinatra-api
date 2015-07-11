class Serializer
  attr_reader :object

  def initialize(object)
    @object = object
  end

  def type
    object.class.name.downcase + 's'
  end

  def base_attributes
    {type: type, id: object.id}
  end

  def attributes
    {}
  end

  def relationships
    {}
  end

  def link
    Bank::BASE_URL + '/api/v1/' + [type, object.id].join('/')
  end

  def data
    base_attributes.tap do |d|
      d.merge!(attributes: attributes) if attributes.any?
      d.merge!(relationships: relationships) if relationships.any?
    end
  end

  def self.generate(object)
    res = {
      links: {'self' => Bank::BASE_URL + Bank.current_path}
    }

    if object.respond_to?(:to_a)
      res['data'] = object.map { |obj| serialize(obj).data }
    else
      res['data'] = serialize(object).data
    end

    res.to_json
  end

  def self.serialize(obj)
    "#{obj.class.name}Serializer".constantize.new(obj)
  end
end
