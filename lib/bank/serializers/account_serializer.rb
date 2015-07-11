class AccountSerializer < Serializer

  def attributes
    {product_cd: object.product_cd}
  end

  def relationships
    {
      customer: {
        links: {
          self: link + '/relationships/customer',
          related: link + '/customer'
        }
      },
      data: {
        type: 'customers',
        id: object.cust_id
      }
    }
  end
end
