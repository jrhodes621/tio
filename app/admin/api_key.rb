ActiveAdmin.register ApiKey do

  permit_params :partner, :access_token, :salt, :deleted

end
