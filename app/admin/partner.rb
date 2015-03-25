ActiveAdmin.register Partner do

  permit_params :partner_name, :company_name, :company_identification, :company_entry_description,
    :immediate_destination, :immediate_destination_name, :immediate_origin,
    :immediate_origin_name, :originating_financial_institution

end
