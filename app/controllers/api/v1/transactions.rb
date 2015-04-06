module API
  module V1
    class Transactions < Grape::API
      version 'v1' # path-based versioning by default
      format :json # We don't like xml anymore

      resource :transactions do
        before do
          #validate_partner
        end

        desc "Creates a transaction"
        params do
            requires :transaction_type, type: String, desc: "type of transaction"
            requires :account_holder_name, type: String, desc: "acct holder name"
            requires :account_type, type: String, desc: "Saving or Checking account"
            requires :routing_number, type: String, desc: "routing number"
            requires :account_number, type: String, desc: "account number"
            requires :amount, type:Integer, desc: "amount of transaction"
        end
        post do

          @partner = Partner.first
          amount = params[:amount].to_f*100
          
          transaction = @partner.transactions.create!({
              :transaction_type => params[:transaction_type],
              :account_type => params[:account_type],
              :routing_number => params[:routing_number],
              :account_number => params[:account_number],
              :amount => amount,
              :individual_name => params[:account_holder_name],
              :transaction_status => "Pending"
          })

          transaction

        end

        get "/" do
          {
            :hello => "James"
          }
        end

        get "/:id" do

        end

        put "/:id" do

        end

        post "/:id/cancel" do

        end

        post "/:id/refund" do

        end

      end
    end
  end
end
