class Accounts < Grape::API
  resource :accounts do
    desc "Returns all accounts.", entity: Account::Entity
    get '/', http_codes: [
      [200, 'Ok', Account::Entity]
    ] do
      present Account.all
    end

    desc "Returns a single account record.", entity: Account::Entity
    params do
      requires :id, type: Integer, desc: "Account id"
    end
    get '/:id', http_codes: [
      [200, 'Ok', Account::Entity],
      [400, "Invalid ID supplied"]
    ] do
      present Account.find(params[:id])
    end
  end
end
