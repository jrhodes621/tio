module API
  module V1
    class FinancialInstitutions < Grape::API
      version 'v1' # path-based versioning by default
      format :json # We don't like xml anymore

      resource :financial_institutions do
        desc "Get all financial institutins"
        get "/" do
          financial_institutions = FinancialInstitution.all

          financial_institutions
        end
      end
    end
  end
end
