require 'securerandom'

module API
  module V1
    class Customers < Grape::API
      version 'v1' # path-based versioning by default
      format :json # We don't like xml anymore

      resource :customers do
        before do
          validate_partner
        end

        desc "Creates a customer"
        params do
            requires :first_name, type: String, desc: "type of transaction"
            requires :last_name, type: String, desc: "acct holder name"
            requires :email, type: String, desc: "Saving or Checking account"
        end
        post do

          customer = @partner.customers.create({
              :first_name => params["first_name"],
              :last_name => params["last_name"],
              :email => params["email"],
              :customer_token => SecureRandom.hex
          })

          customer

        end

        get "/" do
          @partner.customers
        end

        get "/:customer_token" do
          customer = @partner.customers.where(:customer_token => params[:customer_token]).first

          customer
        end

        params do
            optional :first_name, type: String, desc: "type of transaction"
            optional :last_name, type: String, desc: "acct holder name"
            optional :email, type: String, desc: "Saving or Checking account"
        end
        put "/:customer_token" do
          customer =  @partner.customers.where(:customer_token => params[:customer_token]).first
        end

        delete put "/:customer_token" do
          customer =  @partner.customer.where(:customer_token => params[:customer_token]).first

          customer.destroy
        end

      end
    end
  end
end
