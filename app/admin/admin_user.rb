ActiveAdmin.register AdminUser do

  permit_params :access_token, :salt, :deleted, :deleted_at

end
