class Accounts < Grape::API
  resource :accounts do
    desc "Returns all accounts."
    get '/' do
      Account.all
    end

    desc "Returns a single account record."
    params do
      requires :id, type: Integer, desc: "Account id."
    end
    get '/:id' do
      Account.find(params[:id])
    end
  end
end
