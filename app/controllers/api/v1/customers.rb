require 'securerandom'

module API
  module V1
    class Customers < Grape::API
      version 'v1' # path-based versioning by default
      format :json # We don't like xml anymore

      resource :customer do
        before do
          #validate_partner
        end

        desc "Creates a customer"
        params do
            requires :partner_key, type: String, desc: "partner key assigned by TransferIO"
            requires :partner_secret, type: String, desc: "partner secret assign by TransferIO"
            requires :first_name, type: String, desc: "type of transaction"
            requires :last_name, type: String, desc: "acct holder name"
            requires :email, type: String, desc: "Saving or Checking account"
        end
        post do
          partner = Partner.where(:partner_key => params[:partner_key]).first

          customer = partner.customers.create({
              :first_name => params["first_name"],
              :last_name => params["last_name"],
              :email => params["email"],
              :customer_token => SecureRandom.hex
          })

          customer

        end

        get "/" do
          partner = Partner.where(:partner_key => params[:partner_key]).first

          partner.customers
        end

        get "/:customer_token" do
          partner = Partner.where(:partner_key => params[:partner_key]).first

          customer =partner.customer.where(:customer_token => params[:customer_token]).first

          customer
        end

        put "/:customer_token" do
          partner = Partner.where(:partner_key => params[:partner_key]).first

          customer =   partner.customer.where(:customer_token => params[:customer_token]).first
        end

        delete put "/:customer_token" do
          partner = Partner.where(:partner_key => params[:partner_key]).first

          customer =  partner.customer.where(:customer_token => params[:customer_token]).first

          customer.destroy
        end

      end
    end
  end
end
