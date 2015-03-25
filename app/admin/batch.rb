ActiveAdmin.register Batch do

  permit_params :start_time, :end_time, :filename, :batch_status

end
