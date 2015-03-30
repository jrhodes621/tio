module API
  module V1
    class Customers < Grape::API
      version 'v1' # path-based versioning by default
      format :json # We don't like xml anymore

      resource :financial_institions do
        before do
          #validate_partner
        end

        desc "Get all financial institutins"
        get "/" do
          partner = Partner.where(:partner_key => params[:partner_key]).first

          financial_institutions = FinancialInstitution.all

          financial_institutions

        end
      end
    end
  end
end
