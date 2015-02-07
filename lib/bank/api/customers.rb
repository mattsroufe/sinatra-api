class Customers < Grape::API

  resource :customers do
    desc 'Returns all customers.'
    get '/' do
      Customer.all
    end

    desc "Returns a single customer."
    params do
      requires :id, type: Integer, desc: "Customer id."
    end
    get '/:id' do
      Customer.find(params[:id])
    end

    desc "Create a customer."
    params do
      requires :fed_id, type: String, desc: "Customer federal id number."
    end
    post do
      Customer.create!(fed_id: params[:fed_id])
    end

    desc "Returns a single customer's accounts"
    params do
      requires :id, type: Integer, desc: "Customer id."
    end
    get '/:id/accounts' do
      Customer.find(params[:id]).accounts
    end
  end
end
