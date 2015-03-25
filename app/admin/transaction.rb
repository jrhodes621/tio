ActiveAdmin.register Transaction do

  permit_params :transaction_type, :account_type, :routing_number, :account_number,
    :amount, :individual_id_number, :individual_name, :confirmation_number, :transaction_status

end
